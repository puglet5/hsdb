# frozen_string_literal: true

module Api
  class CategoriesController < ApplicationController
    def update
      @category = Category.find params[:id]

      @category.update! category_name: params[:category][:category_name].strip

      head :ok
    end
  end
end
