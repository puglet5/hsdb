class UploadsController < ApplicationController
  before_action :set_upload, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]

  # GET /uploads or /uploads.json
  def index
    @uploads = Upload.all
  end

  # GET /uploads/1 or /uploads/1.json
  def show
  end

  # GET /uploads/new
  def new
    @upload = current_user.uploads.build
  end

  # GET /uploads/1/edit
  def edit
  end

  # POST /uploads or /uploads.json
  def create
    @upload = current_user.uploads.build(upload_params)

    respond_to do |format|
      if @upload.save
        format.html { redirect_to @upload, notice: "Upload was successfully created." }
        format.json { render :show, status: :created, location: @upload }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /uploads/1 or /uploads/1.json
  def update
    respond_to do |format|
      if @upload.update(upload_params)
        format.html { redirect_to @upload, notice: "Upload was successfully updated." }
        format.json { render :show, status: :ok, location: @upload }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uploads/1 or /uploads/1.json
  def destroy
    @upload.destroy
    respond_to do |format|
      format.html { redirect_to uploads_url, notice: "Upload was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_upload
    @upload = Upload.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def upload_params
    params.require(:upload).permit(:title, :description, images: [])
  end
end
