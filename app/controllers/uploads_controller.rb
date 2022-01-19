# frozen_string_literal: true

require('zip')

class UploadsController < ApplicationController
  include BulkDownload

  before_action :authenticate_user!
  before_action :set_upload, only: %i[show edit update destroy]
  before_action :authorize_upload
  after_action :verify_authorized

  # GET /uploads or /uploads.json
  def index
    # @uploads = Upload.all.page(params[:page]).per(5)
    @q = Upload.includes([:user, { images_attachments: :blob }]).ransack(params[:q])
    @uploads = @q.result(distinct: true).page(params[:page]).per(5)
  end

  # GET /uploads/1 or /uploads/1.json
  def show
    respond_to do |format|
      format.html do
        @upload = Upload.find(params[:id])
      end

      format.zip { bulk_download }
    end
  end

  # GET /uploads/new
  def new
    @upload = current_user.uploads.build
  end

  # GET /uploads/1/edit
  def edit; end

  # POST /uploads or /uploads.json
  def create
    @upload = current_user.uploads.build(upload_params)

    respond_to do |format|
      if @upload.save
        flash[:success] = 'Upload was successfully created'
        format.html { redirect_to @upload }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /uploads/1 or /uploads/1.json
  def update
    @upload.user = current_user if @upload.user.nil?
    respond_to do |format|
      if @upload.update(upload_params.reject { |k| k['images'] })
        if upload_params[:images].present?
          upload_params[:images].each do |image|
            @upload.images.attach(image)
          end
        end
        flash[:success] = 'Upload was successfully updated'
        format.html { redirect_to @upload }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
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

  # DELETE /uploads/1 or /uploads/1.json
  def destroy
    @upload.destroy
    respond_to do |format|
      flash[:success] = 'Upload was successfully deleted'
      format.html { redirect_to uploads_url }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_upload
    @upload = Upload.includes([images_attachments: :blob]).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def upload_params
    params.require(:upload).permit(:title, :body, :description, :status, images: [], documents: [])
  end

  def authorize_upload
    authorize(@upload || Upload)
  end
end
