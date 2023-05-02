# frozen_string_literal: true

class SamplesController < ApplicationController
  include ActiveStorage::SendZip

  before_action :set_sample, only: %i[show edit update destroy]
  after_action :verify_authorized

  breadcrumb 'Home', :root
  breadcrumb 'Samples', :samples, match: :exclusive

  def index
    samples = Sample.all.order('created_at asc')

    authorize samples

    @query = samples.ransack(params[:query])
    @pagy, @samples = pagy @query.result(distinct: true).order('created_at DESC'), items: 20
  end

  def compare
    @spectra = Spectrum.find(params[:ids])

    breadcrumb 'Compare', %i[compare samples], match: :exclusive

    authorize Sample
  end

  def show
    @sample = Sample.with_attached_documents
                    .with_attached_images
                    .includes(:spectra)
                    .find(params[:id])
    @spectra = @sample.spectra

    authorize @sample

    @raw_files = @spectra&.select \
    { |s| s.file.attached? } \
                         &.map(&:file)

    @processed_files = @spectra&.select \
      { |s| s.processed_file.attached? } \
                               &.map(&:processed_file)

    json_data = SampleSerializer.new(@sample).to_json

    respond_to do |format|
      format.html do
        breadcrumb @sample.title, @sample, match: :exclusive
      end
      format.zip do
        redirect_to @sample unless params['data']

        case params['data']
        when 'raw'
          send_zip @raw_files, filename: "#{@sample.title} — Raw Spectra — #{Time.zone.now.to_fs(:short)}.zip"
        when 'prc'
          send_zip @processed_files, filename: "#{@sample.title} — Processed Spectra — #{Time.zone.now.to_fs(:short)}.zip"
        when 'img'
          send_zip @sample.images, filename: "#{@sample.title} — Images — #{Time.zone.now.to_fs(:short)}.zip"
        when 'doc'
          send_zip @sample.documents, filename: "#{@sample.title} — Documents — #{Time.zone.now.to_fs(:short)}.zip"
        when 'json'
          send_data json_data, filename: "#{@sample.title} — #{Time.zone.now.to_fs(:short)}.json"
        else
          redirect_to @sample
        end
      end
    end
  end

  def new
    @sample = current_user.samples.build sample_params

    authorize @sample

    @sample.spectra.build

    breadcrumb 'New Sample', %i[new sample], match: :exclusive
  end

  def edit
    authorize @sample

    @sample.spectra.build

    breadcrumb @sample.title, @sample, match: :exclusive
    breadcrumb 'Edit', [:edit, @sample], match: :exclusive
  end

  def create
    @sample = current_user.samples.build(sample_params)
    @sample.spectra.each { |s| s.user = current_user }

    authorize @sample

    if @sample.save
      redirect_to @sample
      flash[:success] = 'Sample added!'
    else
      @spectra = @sample.spectra.build
      render :new, status: :unprocessable_entity
    end
  end

  def favorite
    @sample = Sample.find params[:id]
    authorize @sample

    if current_user.favorited? @sample
      current_user.unfavorite @sample
    else
      current_user.favorite @sample
    end
    redirect_to @sample
  end

  def update
    authorize @sample

    unless sample_params[:spectra_attributes].nil?
      @spectra = @sample.spectra.build(sample_params[:spectra_attributes])
      @spectra.each { |s| s.user = current_user }
    end

    if @sample.update(sample_params.except(:spectra_attributes))
      @spectra&.each(&:save!)

      attachment_params[:purge_attachments]&.each do |signed_id|
        purge_attachment signed_id
      end

      redirect_to @sample
      flash[:success] = 'Sample updated!'
    else
      render :edit, status: :unprocessable_entity
    end
  rescue ActiveRecord::StaleObjectError
    flash[:error] = 'Error! Sample was modified elsewhere.'
    redirect_to [:edit, @sample]
  end

  def destroy
    authorize @sample

    @sample.destroy
    flash[:success] = 'Sample deleted!'
    redirect_to samples_url, status: :see_other
  end

  private

  def set_sample
    @sample = Sample.find(params[:id])
  end

  def purge_attachment(signed_id)
    @blob = ActiveStorage::Blob.find_signed signed_id
    @blob.attachments.first.purge_later
  end

  def sample_params
    params.fetch(:sample, {}).permit(
      :title,
      :metadata,
      :category,
      :origin,
      :owner,
      :description,
      :lock_version,
      :sku,
      :color,
      :formula,
      :cas_no,
      :cas_name,
      :survey_date,
      :is_reference,
      spectra_attributes: %i[id file],
      images: [],
      documents: []
    )
  end

  def attachment_params
    params.require(:sample).permit(
      purge_attachments: []
    )
  end
end
