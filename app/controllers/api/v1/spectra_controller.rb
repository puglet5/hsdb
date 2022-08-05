# frozen_string_literal: true

module Api
  module V1
    class SpectraController < ApiController
      def index
        @spectra = Spectrum.all
        render json: @spectra
      end

      def show
        @spectrum = Spectrum.find_by id: params[:id]
        render json: @spectrum
      end
    end
  end
end
