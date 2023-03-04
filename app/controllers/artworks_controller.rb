# frozen_string_literal: true

class ArtworksController < ApplicationController
  include ActiveStorage::SendZip
  include PurgeImage

  before_action :authenticate_user!
  before_action :fetch_tags, only: %i[new edit]
  before_action :fetch_materials, only: %i[new edit]

  after_action :verify_authorized

  breadcrumb 'Home', :root
  breadcrumb 'Artworks', :artworks, match: :exact

  def index
    @artworks = Artwork
                .all
                .includes(:user, :style)
                .with_attached_thumbnail

    authorize @artworks

    @query = @artworks.ransack(params[:query])
    @pagy, @artworks = pagy @query.result(distinct: true).order('created_at DESC'), items: current_user&.settings(:pagination)&.per || 10
  end

  def show
    @artwork = Artwork.find(params[:id])
    authorize @artwork

    respond_to do |format|
      format.html do
        @artwork = Artwork
                   .find(params[:id])

        @documents = @artwork
                     .documents
                     .all
      end

      format.zip do
        send_zip @artwork.image_attachments, filename: "#{@artwork.title} — #{Time.zone.now.to_fs(:long)}.zip"
      end
    end

    breadcrumb @artwork.title, @artwork, match: :exclusive
  end

  def images_grid
    @artwork = Artwork
               .find(params[:id])

    authorize @artwork

    @q = @artwork.images
                 .all
                 .with_attached_image
                 .order('created_at ASC')

    @pagy, @images = pagy @q, items: 20

    render layout: false
  end

  def images
    @artworks = Artwork.all
  end

  def new
    @artwork = current_user.artworks.build
    @artwork.images.build

    authorize @artwork

    breadcrumb 'New Artwork', %i[new artwork], match: :exclusive
  end

  def edit
    @artwork = Artwork
               .with_attached_documents
               .find(params[:id])

    authorize @artwork

    @documents = @artwork.documents.all
    @images = @artwork
              .images
              .all
              .with_attached_image

    breadcrumb @artwork.title, @artwork, match: :exclusive
    breadcrumb 'Edit', [:edit, @artwork], match: :exclusive
  end

  def create
    @artwork = current_user.artworks.build(artwork_params)

    authorize @artwork

    if @artwork.save
      flash[:success] = 'Artwork was successfully created'
      redirect_to @artwork
    else
      @artwork.images.build
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @artwork = Artwork
               .includes(:image_attachments)
               .with_attached_thumbnail
               .with_attached_documents
               .find(params[:id])

    authorize @artwork

    @documents = @artwork.documents.all
    @images = @artwork
              .images
              .all
              .with_attached_image

    @artwork.user = current_user if @artwork.user.nil?

    if @artwork.update(artwork_params)

      attachment_params[:purge_attachments]&.each do |signed_id|
        purge_image signed_id
      end

      flash[:success] = 'Artwork was successfully updated'
      redirect_to @artwork
    else
      render :edit, status: :unprocessable_entity
    end
  rescue ActiveRecord::StaleObjectError
    flash[:error] = 'Artwork was modified elsewhere'
    redirect_to [:edit, @artwork]
  end

  def update_status
    @artwork = Artwork.find(params[:id])

    authorize @artwork

    return unless @artwork.update(status: params[:status])

    redirect_to @artwork
    flash.now[:success] = "Status successfully changed to #{@artwork.status}"
  end

  def destroy
    @artwork = Artwork.find(params[:id])

    authorize @artwork

    @artwork.destroy
    flash[:success] = 'Artwork was successfully deleted'
    redirect_to artworks_url, status: :see_other
  end

  def favorite
    @artwork = Artwork.find params[:id]
    authorize @artwork

    if current_user.favorited? @artwork
      current_user.unfavorite @artwork
    else
      current_user.favorite @artwork
    end
    redirect_to(request.referer || :root)
  end

  private

  def fetch_tags
    @tags = Tag.all
  end

  def fetch_materials
    @materials = Material.all
  end

  def artwork_params
    params.require(:artwork).permit(
      :title,
      :body,
      :description,
      :status,
      :style_id,
      :thumbnail,
      :metadata,
      :date,
      :survey_date,
      :lock_version,
      images_attributes: %i[id image],
      image_attachments: [],
      documents: [],
      tag_ids: [],
      material_ids: []
    )
  end

  def attachment_params
    params.require(:artwork).permit(
      purge_attachments: []
    )
  end
end
