# frozen_string_literal: true

class SamplesController < ApplicationController
  before_action :set_sample, only: %i[show edit update destroy]

  breadcrumb 'Home', :root_path
  breadcrumb 'Samples', :samples_path, match: :exact

  def index
    @samples = Sample.all.order('created_at asc')
  end

  def show
    @sample = Sample.find(params[:id])
    @spectra = @sample.spectra

    breadcrumb @sample.title, sample_path(@sample), match: :exclusive
  end

  def new
    @sample = Sample.new
    @sample.spectra.build

    breadcrumb 'New Sample', new_sample_path(@sample), match: :exclusive
  end

  def edit
    breadcrumb @sample.title, sample_path(@sample), match: :exclusive
    breadcrumb 'Edit', edit_sample_path(@sample), match: :exclusive
  end

  def create
    @sample = current_user.samples.build(sample_params)

    if @sample.save
      redirect_to @sample
      flash.now[:success] = 'Sample was successfully created'
    else
      @sample.spectra.build
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @sample.update(sample_params)

      attachment_params[:purge_attachments]&.each do |signed_id|
        purge_attachment signed_id
      end

      redirect_to @sample
      flash.now[:success] = 'Sample was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  rescue ActiveRecord::StaleObjectError
    flash[:error] = 'Sample was modified elsewhere'
    redirect_to [:edit, @sample]
  end

  def destroy
    @sample.destroy
    flash[:success] = 'Sample was successfully deleted'
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
