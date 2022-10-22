# frozen_string_literal: true

class UploadsController < ApplicationController
  include ActiveStorage::SendZip
  include PurgeImage

  before_action :authenticate_user!
  before_action :fetch_tags, only: %i[new edit]
  before_action :fetch_materials, only: %i[new edit]

  after_action :verify_authorized

  def index
    @uploads = Upload
               .all
               .includes(:user)

    authorize @uploads

    @query = @uploads.ransack(params[:query])
    @pagy, @uploads = pagy @query.result(distinct: true).order('created_at DESC'), items: current_user&.settings(:pagination)&.per || 10
  end

  def show
    @upload = Upload.find(params[:id])
    authorize @upload

    respond_to do |format|
      format.html do
        @upload = Upload
                  .find(params[:id])

        @documents = @upload
                     .documents
                     .all
      end

      format.zip do
        send_zip @upload.image_attachments, filename: "#{@upload.title} — #{Time.zone.now.to_fs(:long)}.zip"
      end
    end
  end

  def images_grid
    @upload = Upload
              .find(params[:id])

    authorize @upload

    @q = @upload.images
                .all
                .with_attached_image
                .order('created_at ASC')

    @pagy, @images = pagy @q, items: 20

    render layout: false
  end

  def images
    @uploads = Upload.all
  end

  def new
    @upload = current_user.uploads.build
    @upload.images.build

    authorize @upload
  end

  def edit
    @upload = Upload
              .with_attached_documents
              .find(params[:id])

    authorize @upload

    @documents = @upload.documents.all
    @images = @upload
              .images
              .all
              .with_attached_image
  end

  def create
    @upload = current_user.uploads.build(upload_params)

    authorize @upload

    if @upload.save
      flash[:success] = 'Upload was successfully created'
      redirect_to @upload
    else
      @upload.images.build
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @upload = Upload
              .includes(:image_attachments)
              .with_attached_thumbnail
              .with_attached_documents
              .find(params[:id])

    authorize @upload

    @documents = @upload.documents.all
    @images = @upload
              .images
              .all
              .with_attached_image

    @upload.user = current_user if @upload.user.nil?

    if @upload.update(upload_params)

      attachment_params[:purge_images]&.each do |signed_id|
        purge_image signed_id
      end

      flash[:success] = 'Upload was successfully updated'
      redirect_to @upload
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_status
    @upload = Upload.find(params[:id])

    authorize @upload

    return unless @upload.update(status: params[:status])

    redirect_to @upload
    flash.now[:success] = "Status successfully changed to #{@upload.status}"
  end

  def destroy
    @upload = Upload.find(params[:id])

    authorize @upload

    @upload.destroy
    flash[:success] = 'Upload was successfully deleted'
    redirect_to uploads_url, status: :see_other
  end

  private

  def fetch_tags
    @tags = Tag.all
  end

  def fetch_materials
    @materials = Material.all
  end

  def upload_params
    params.require(:upload).permit(
      :title,
      :body,
      :description,
      :status,
      :style_id,
      :thumbnail,
      :metadata,
      :date,
      :survey_date,
      images_attributes: %i[id image],
      image_attachments: [],
      documents: [],
      tag_ids: [],
      material_ids: []
    )
  end

  def attachment_params
    params.require(:upload).permit(
      purge_images: []
    )
  end
end
