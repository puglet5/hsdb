# frozen_string_literal: true

module Api
  module V1
    class UploadsController < ApiController
      def index
        @uploads = Upload.all
        render json: @uploads
      end
    end
  end
end
