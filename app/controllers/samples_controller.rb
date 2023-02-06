# frozen_string_literal: true

class SamplesController < ApplicationController
  before_action :set_sample, only: %i[show edit update destroy]
  after_action :verify_authorized

  breadcrumb 'Home', :root
  breadcrumb 'Samples', :samples, match: :exclusive

  def index
    samples = Sample.all.order('created_at asc')
    @query = samples.ransack(params[:query])
    @samples = @query.result(distinct: true).order('created_at DESC')

    authorize @samples
  end

  def show
    @sample = Sample.find(params[:id])
    @spectra = @sample
               .spectra
               .with_attached_file
               .with_attached_settings

    authorize @sample

    breadcrumb @sample.title, @sample, match: :exclusive
  end

  def new
    @sample = current_user.samples.build

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
      @spectra.each(&:save!) unless @spectra.nil?

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
    params.require(:sample).permit(
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
