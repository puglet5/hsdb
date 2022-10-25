# frozen_string_literal: true

class SpectraController < ApplicationController
  before_action :set_spectrum, only: %i[show edit update destroy]

  def index
    @spectra = Spectrum.all.order('created_at asc')
  end

  def show
    @spectrum = Spectrum
                .find(params[:id])
  end

  def new
    @spectrum = Spectrum.new
  end

  def edit; end

  def create
    @spectrum = current_user.spectra.build(spectrum_params)

    if @spectrum.save

      if spectrum_params[:files]&.present? && current_user.settings(:processing).enabled == 'true'
        @spectrum.processing_pending!
        ProcessCsvJob.perform_later current_user, @spectrum.id
      end

      redirect_to @spectrum
      flash.now[:success] = 'Spectrum was successfully created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @spectrum.update(spectrum_params.reject { |k| k['csvs'] })
      redirect_to @spectrum
      flash.now[:success] = 'Spectrum was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @spectrum.destroy
    flash[:success] = 'Spectrum was successfully deleted'
    redirect_to spectra_url, status: :see_other
  end

  private

  def set_spectrum
    @spectrum = Spectrum.find(params[:id])
  end

  def spectrum_params
    params.require(:spectrum).permit(
      :title,
      :metadata,
      :category,
      :origin,
      :owner,
      :description,
      spectrum_file_attributes: %i[id file],
      images: [],
      documents: []
    )
  end
end
