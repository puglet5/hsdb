# frozen_string_literal: true

class SpectraController < ApplicationController
  before_action :set_sample

  def show
    @spectrum = @sample.spectra.find_by id: params[:id]
    render partial: 'samples/spectrum_tab', locals: { spectrum: @spectrum }
  end

  def new
    @spectrum = Spectrum.new

    breadcrumb 'Home', :root
    breadcrumb 'Samples', :samples, match: :exact
    breadcrumb @sample.title, @sample, match: :exact
    breadcrumb 'New Spectrum', [:new, @sample, :spectrum], match: :exclusive
  end

  def edit
    @spectrum = @sample.spectra.find(params[:id])

    breadcrumb 'Home', :root
    breadcrumb 'Samples', :samples, match: :exact
    breadcrumb @sample.title, @sample, match: :exact
    breadcrumb "#{ApplicationHelper.humanize_category @spectrum.category}, #{ApplicationHelper.humanize_file_format @spectrum.format}", @sample, match: :exact
    breadcrumb 'Edit', [:edit, @sample, @spectrum], match: :exclusive
  end

  def create
    @spectrum = @sample.spectra.build(spectrum_params)
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

    if @spectrum.update(spectrum_params)
      redirect_to @sample
      flash[:success] = 'Spectrum updated!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @spectrum = @sample.spectra.find(params[:id])

    @spectrum.destroy
    flash[:success] = 'Spectrum deleted!'
    redirect_to @sample, status: :see_other
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
      :settings
    )
  end

  def set_sample
    @sample = Sample.find(params[:sample_id])
  end
end
