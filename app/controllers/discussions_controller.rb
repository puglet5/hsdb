# frozen_string_literal: true

class DiscussionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_discussion, only: %i[show edit update destroy]
  before_action :find_categories, only: %i[index show new edit]
  before_action :authorize_discussion
  after_action :verify_authorized

  # , except: [:index, :show]

  def index
    @discussion = Discussion.all.order('created_at desc')
    @discussions_unpinned = Discussion.all.where(pinned: false).order('created_at desc')
    @discussions_pinned = Discussion.all.where(pinned: true).order('created_at desc')
  end

  def show
    @discussions = Discussion.all.order('created_at desc')
    @discussions_unpinned = Discussion.all.where(pinned: false).order('created_at desc')
    @discussions_pinned = Discussion.all.where(pinned: true).order('created_at desc')
  end

  def new
    @discussion = current_user.discussions.build
  end

  def edit; end

  def create
    @discussion = current_user.discussions.build(discussion_params)

    respond_to do |format|
      if @discussion.save
        format.html { redirect_to @discussion, notice: 'Discussion was successfully created.' }
        format.json { render :show, status: :created, location: @discussion }
      else
        format.html { render :new }
        format.json { render json: @discussion.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @discussion.update(discussion_params)
        format.html { redirect_to @discussion, notice: 'Discussion was successfully updated.' }
        format.json { render :show, status: :ok, location: @discussion }
      else
        format.html { render :edit }
        format.json { render json: @discussion.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @discussion.destroy
    redirect_to discussions_url, notice: 'Discussion was successfully deleted.', status: :see_other
  end

  private

  def set_discussion
    @discussion = Discussion.find(params[:id])
  end

  def find_categories
    @categories = Category.all.order('created_at asc')
  end

  def discussion_params
    params.require(:discussion).permit(:title, :content, :category_id)
  end

  def authorize_discussion
    authorize(@discussion || Discussion)
  end
end
