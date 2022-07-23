# frozen_string_literal: true

class SpectraController < ApplicationController
  include ActiveStorage::SetCurrent

  before_action :set_spectrum, only: %i[show edit update destroy]

  def index
    @spectra = Spectrum.all.order('created_at asc')
  end

  def show; end

  def new
    @spectrum = Spectrum.new
  end

  def edit; end

  def create
    @spectrum = current_user.spectra.build(spectrum_params)

    if @spectrum.save
      ProcessCsvJob.perform_later current_user, @spectrum.id
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
    flash[:success] = 'Spectrum was successfully deleted'
    redirect_to spectra_url, status: :see_other
  end

  def purge_attachment
    @blob = ActiveStorage::Blob.find_signed(params[:id])
    @blob.attachments.first.purge_later
  end

  private

  def set_spectrum
    @spectrum = Spectrum.find(params[:id])
  end

  def spectrum_params
    params.require(:spectrum).permit(:title, :metadata, files: [], processed_csvs: [])
  end
end
