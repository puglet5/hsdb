# frozen_string_literal: true

module Api
  module V1
    class SamplesController < ApiController
      def index
        @samples = Sample.all
        render json: @samples
      end

      def show
        @sample = Sample.find_by(id: params[:id]) or not_found
        render json: @sample
      end
    end
  end
end
