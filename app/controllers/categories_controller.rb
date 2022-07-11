# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show edit update destroy]
  before_action :fetch_categories, only: %i[index show]
  before_action :authorize_category
  after_action :verify_authorized
  # access all: [:index, :show, :new, :edit, :create, :update, :destroy], user: :all

  # GET /categories
  def index
    @discussions = Discussion.all.includes(%i[user category rich_text_content replies]).order('created_at desc')
    @discussions_unpinned = @discussions.where(pinned: false).order('created_at desc')
    @discussions_pinned = @discussions.where(pinned: true).order('created_at desc')
  end

  # GET /categories/1
  def show
    @discussions = Discussion.where(category_id: @category.id).includes(%i[user category rich_text_content replies])
    @discussions_unpinned = @discussions.where(category_id: @category.id, pinned: false).order('created_at desc')
    @discussions_pinned = @discussions.where(category_id: @category.id, pinned: true).order('created_at desc')
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit; end

  # POST /categories
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_path, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: 'Category was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /categories/1
  def destroy
    @category.destroy
    redirect_to categories_url, notice: 'Category was successfully deleted.', status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = Category.find(params[:id])
  end

  def fetch_categories
    @categories = Category.all.includes([:discussions]).order('created_at asc')
  end

  # Only allow a trusted parameter "white list" through.
  def category_params
    params.require(:category).permit(:category_name)
  end

  def authorize_category
    authorize(@category || Category)
  end
end
