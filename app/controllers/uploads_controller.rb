# frozen_string_literal: true

require('zip')

class UploadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_upload, only: %i[show edit update destroy]

  # GET /uploads or /uploads.json
  def index
    # @uploads = Upload.all.page(params[:page]).per(5)
    @q = Upload.ransack(params[:q])
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

  # DELETE /uploads/1 or /uploads/1.json
  def destroy
    @upload.destroy
    respond_to do |format|
      flash[:success] = 'Upload was successfully destroyed'
      format.html { redirect_to uploads_url }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_upload
    @upload = Upload.find(params[:id])
  end

  def bulk_download
    filename = "#{@upload.title}#{Time.current}.zip"
    temp_file = Tempfile.new(filename)

    begin
      Zip::OutputStream.open(temp_file) { |zos| }

      Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|
        @upload.images.all.each do |attachment|
          File.open(Tempfile.new(attachment.filename.to_s), 'w', encoding: 'ASCII-8BIT') do |file|
            attachment.download do |chunk|
              file.write(chunk)
            end
            zip.add(attachment.filename.to_s, file.path)
          end
        end
      end

      zip_data = File.read(temp_file.path)
      send_data(zip_data, type: 'application/zip', disposition: 'attachment', filename: filename)
    ensure
      temp_file.close
      temp_file.unlink
    end
  end

  # Only allow a list of trusted parameters through.
  def upload_params
    params.require(:upload).permit(:title, :body, :description, images: [], documents: [])
  end
end
