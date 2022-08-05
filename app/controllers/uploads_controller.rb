# frozen_string_literal: true

class UploadsController < ApplicationController
  include ActiveStorage::SendZip
  include ActiveStorage::SetCurrent

  before_action :authenticate_user!
  before_action :fetch_tags, only: %i[new edit update]
  after_action :verify_authorized

  def index
    @uploads = Upload.all

    authorize @uploads

    @q = @uploads.ransack(params[:q])
    @pagy, @uploads = pagy @q.result(distinct: true).order('created_at DESC'), items: current_user&.settings(:pagination)&.per || 10
  end

  def show
    @upload = Upload.find(params[:id])
    authorize @upload

    respond_to do |format|
      format.html do
        @upload = Upload
                  .with_attached_thumbnail
                  .with_attached_images
                  .with_attached_documents
                  .find(params[:id])
        @images = @upload
                  .images.all
                  .with_all_variant_records

        @document = @upload.documents.all
      end

      format.zip do
        send_zip @upload.images, filename: "#{@upload.title} — #{Time.zone.now.to_fs(:long)}.zip"
      end
    end
  end

  def images
    @uploads = Upload.all
  end

  def new
    @upload = current_user.uploads.build

    authorize @upload
  end

  def edit
    @upload = Upload
              .with_attached_images
              .with_attached_documents
              .find(params[:id])

    authorize @upload

    @images = @upload.images.all.with_all_variant_records
    @document = @upload.documents.all
  end

  def create
    @upload = current_user.uploads.build(upload_params)

    authorize @upload

    if @upload.save
      flash[:success] = 'Upload was successfully created'
      redirect_to @upload
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @upload = Upload
              .with_attached_thumbnail
              .find(params[:id])

    authorize @upload

    @images = @upload.images.all
    @document = @upload.documents.all

    @upload.user = current_user if @upload.user.nil?
    @images_count_pre = @images.count unless @images_count_err

    if @upload.update(upload_params)
      flash[:success] = 'Upload was successfully updated'
      redirect_to @upload
    else
      @images_count_err = @images.count
      render :edit, status: :unprocessable_entity
    end
  end

  def update_status
    @upload = Upload.find(params[:id])

    authorize @upload

    return unless @upload.update(status: params[:status])

    redirect_to @upload
    flash[:success] = "Status successfully changed to #{@upload.status}"
  end

  def destroy
    @upload = Upload.find(params[:id])

    authorize @upload

    @upload.destroy
    flash[:success] = 'Upload was successfully deleted'
    redirect_to uploads_url, status: :see_other
  end

  def purge_attachment
    @blob = ActiveStorage::Blob.find_signed(params[:id])
    @attachment = ActiveStorage::Attachment.where(blob_id: @blob.id).first
    @upload = Upload.find @attachment.record_id

    authorize @upload

    @blob.attachments.first.purge_later
  end

  private

  def fetch_tags
    @tags = Tag.all
  end

  def upload_params
    params.require(:upload).permit(
      :title,
      :body,
      :description,
      :status,
      :thumbnail,
      :metadata,
      images: [],
      documents: [],
      tag_ids: []
    )
  end
end
