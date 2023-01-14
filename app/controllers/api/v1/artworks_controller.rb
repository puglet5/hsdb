# frozen_string_literal: true

module Api
  module V1
    class ArtworksController < ApiController
      def index
        @artworks = Artwork.all
        render json: @artworks
      end

      def show
        @artwork = Artwork.find_by(id: params[:id]) or not_found
        render json: @artwork
      end
    end
  end
end
