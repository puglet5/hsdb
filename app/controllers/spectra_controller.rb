# frozen_string_literal: true

class SpectraController < ApplicationController
  before_action :set_spectrum, only: %i[show edit update destroy]

  def index
    @spectra = Spectrum.all
  end

  def show; end

  def new
    @spectrum = Spectrum.new
  end

  def edit; end

  def create
    @spectrum = current_user.spectra.build(spectrum_params)

    if @spectrum.save
      redirect_to @spectrum
      flash[:success] = 'Spectrum was successfully created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @spectrum.update(spectrum_params.reject { |k| k['csvs'] })

      if spectrum_params[:csvs].present?
        spectrum_params[:csvs].each do |csv|
          @spectrum.csvs.attach(csv)
        end
      end

      redirect_to @spectrum
      flash[:success] = 'Spectrum was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @spectrum.destroy
    redirect_to spectra_url
    flash[:success] = 'Spectrum was deleted.'
  end

  private

  def set_spectrum
    @spectrum = Spectrum.find(params[:id])
  end

  def spectrum_params
    params.require(:spectrum).permit(:title, csvs: [])
  end
end
