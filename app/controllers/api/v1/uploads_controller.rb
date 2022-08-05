# frozen_string_literal: true

module Api
  module V1
    class UploadsController < ApiController
      def index
        @uploads = Upload.all
        render json: @uploads
      end

      def show
        @upload = Upload.find_by id: params[:id]
        render json: @upload
      end
    end
  end
end
