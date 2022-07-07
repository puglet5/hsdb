# frozen_string_literal: true

require('zip')

class UploadsController < ApplicationController
  include BulkDownload

  before_action :authenticate_user!
  before_action :set_upload, only: %i[show edit update destroy]
  before_action :fetch_tags, only: %i[new edit update]

  before_action :authorize_upload
  after_action :verify_authorized

  def index
    @uploads = Upload.all.page(params[:page]).per(3)
    @q = Upload.includes([:user, { images_attachments: :blob }]).ransack(params[:q])
    @uploads = @q.result(distinct: true).page(params[:page]).per(20)
  end

  def show
    respond_to do |format|
      format.html do
        @upload = Upload.find(params[:id])
      end

      format.zip { bulk_download }
      # format.pdf do
      #   render pdf: "Upload_#{@upload.id}", template: "uploads/show.html.erb"
      # end
    end
  end

  def new
    @upload = current_user.uploads.build
  end

  def edit; end

  def create
    @upload = current_user.uploads.build(upload_params)

    if @upload.save
      flash[:success] = 'Upload was successfully created'
      redirect_to @upload
    else
      render :new, status: :unprocessable_entity
    end
    ActiveStorage::Blob.unattached.each(&:purge_later)
  end

  def update
    @upload.user = current_user if @upload.user.nil?
    if @upload.update(upload_params.reject { |k| k['images'] })
      if upload_params[:images].present?
        upload_params[:images].each do |image|
          @upload.images.attach(image)
        end
      end
      flash[:success] = 'Upload was successfully updated'
      redirect_to @upload
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_status
    @upload = Upload.find(params[:id])
    respond_to do |format|
      if @upload.update(status: params[:status])
        format.html { redirect_to @upload }
        flash[:success] = "Status successfully changed to #{@upload.status}"
      end
    end
  end

  def destroy
    @upload.destroy
    flash[:success] = 'Upload was successfully deleted'
    redirect_to uploads_url, status: :see_other
  end

  private

  def set_upload
    @upload = Upload.includes([images_attachments: :blob]).find(params[:id])
  end

  def fetch_tags
    @tags = Tag.all
  end

  # Only allow a list of trusted parameters through.
  def upload_params
    params.require(:upload).permit(:title, :body, :description, :status, :thumbnail, images: [], documents: [], tag_ids: [])
  end

  def authorize_upload
    authorize(@upload || Upload)
  end
end
