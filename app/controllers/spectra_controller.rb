# frozen_string_literal: true

class SpectraController < ApplicationController
  before_action :set_sample
  after_action :verify_authorized

  def show_processing_indicator
    @spectrum = @sample.spectra.find_by id: params[:id]
    authorize @spectrum

    render partial: 'samples/spectrum_processing_indicator', locals: { spectrum: @spectrum }
  end

  def show_request_processing_button
    @spectrum = @sample.spectra.find_by id: params[:id]
    authorize @spectrum

    render partial: 'samples/spectrum_request_processing_button', locals: { spectrum: @spectrum, sample: @sample }
  end

  def show_chart_area
    @spectrum = @sample.spectra.find_by id: params[:id]
    authorize @spectrum

    render partial: 'samples/spectrum_chart_area', locals: { spectrum: @spectrum, sample: @sample }
  end

  def new
    @spectrum = Spectrum.new

    authorize @spectrum

    breadcrumb 'Home', :root
    breadcrumb 'Samples', :samples, match: :exact
    breadcrumb @sample.title, @sample, match: :exact
    breadcrumb 'New Spectrum', [:new, @sample, :spectrum], match: :exclusive
  end

  def edit
    @spectrum = @sample.spectra.find(params[:id])

    authorize @spectrum

    breadcrumb 'Home', :root
    breadcrumb 'Samples', :samples, match: :exact
    breadcrumb @sample.title, @sample, match: :exact
    breadcrumb "#{ApplicationHelper.humanize_category @spectrum.category}, #{ApplicationHelper.humanize_file_format @spectrum.format}", @sample, match: :exact
    breadcrumb 'Edit', [:edit, @sample, @spectrum], match: :exclusive
  end

  def create
    @spectrum = @sample.spectra.build(spectrum_params)

    authorize @spectrum

    @spectrum.user = current_user

    if @spectrum.save
      redirect_to @sample
      flash[:success] = 'Spectrum added!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @spectrum = @sample.spectra.find(params[:id])

    authorize @spectrum

    if @spectrum.update(spectrum_params)
      redirect_to @sample
      flash[:success] = 'Spectrum updated!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @spectrum = @sample.spectra.find(params[:id])

    authorize @spectrum

    @spectrum.destroy
    flash[:success] = 'Spectrum deleted!'
    redirect_to @sample, status: :see_other
  end

  def request_processing
    @spectrum = @sample.spectra.find(params[:id])

    authorize @spectrum

    return if @spectrum.processing_pending? || @spectrum.processing_ongoing? || @spectrum.processing_successful?

    @spectrum.processing_pending!
    SendProcessingRequestJob.perform_later @spectrum
    respond_to do |format|
      format.html do
        render partial: 'samples/spectrum_request_processing_button', locals: { spectrum: @spectrum, sample: @sample }
      end
    end
  end

  private

  def spectrum_params
    params.require(:spectrum).permit(
      :file,
      :category,
      :range,
      :metadata,
      :description,
      :equipment,
      :settings,
      :sample_thickness,
      :is_reference
    )
  end

  def set_sample
    @sample = Sample.find(params[:sample_id])
  end
end
