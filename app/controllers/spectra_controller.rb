# frozen_string_literal: true

class SpectraController < ApplicationController
  before_action :set_sample

  def new
    @spectrum = Spectrum.new

    breadcrumb 'Home', :root_path
    breadcrumb 'Samples', :samples_path, match: :exact
    breadcrumb @sample.title, sample_path(@sample), match: :exact
    breadcrumb 'New Spectrum', [:new, @sample, :spectrum], match: :exclusive
  end

  def create
    @spectrum = @sample.spectra.build(spectrum_params)

    if @spectrum.save
      redirect_to @sample
      flash.now[:success] = 'Spectrum added!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @spectrum = @sample.spectra.find(params[:id])

    @spectrum.destroy
    flash[:success] = 'Spectrum removed!'
    redirect_to @sample, status: :see_other
  end

  private

  def spectrum_params
    params.require(:spectrum).permit(
      :file,
      :format,
      :status,
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
