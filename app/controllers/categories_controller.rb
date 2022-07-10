# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :set_categories, only: %i[index show edit update destroy]
  before_action :authorize_category
  after_action :verify_authorized

  def index
    @discussions = Discussion.all.order('created_at desc')
    @discussions_unpinned = Discussion.all.where(pinned: false).order('created_at desc')
    @discussions_pinned = Discussion.all.where(pinned: true).order('created_at desc')
  end

  def show
    @discussions = Discussion.where(category_id: @category.id)
    @discussions_unpinned = Discussion.all.where(category_id: @category.id, pinned: false).order('created_at desc')
    @discussions_pinned = Discussion.all.where(category_id: @category.id, pinned: true).order('created_at desc')
  end

  def new
    @category = Category.new
  end

  def edit; end

  def create
    @category = Category.new(category_params)

    if @category.save
        redirect_to categories_path, notice: 'Category was successfully created.'
    else
        render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: 'Category was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_url, notice: 'Category was successfully deleted.', status: :see_other
  end

  private

  def set_categories
    @categories = Category.all.order('created_at asc')
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:category_name)
  end

  def authorize_category
    authorize(@category || Category)
  end
end
