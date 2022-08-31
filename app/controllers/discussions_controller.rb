# frozen_string_literal: true

class DiscussionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_discussion, only: %i[show edit update destroy]
  before_action :fetch_discussions, only: %i[index show]
  before_action :authorize_discussion
  after_action :verify_authorized

  def index
    @categories = Category.all.includes([:discussions]).order('created_at asc')
    @discussions_unpinned = @discussions.where(pinned: false).order('created_at desc')
    @discussions_pinned = @discussions.where(pinned: true).order('created_at desc')
  end

  def show
    @discussions_unpinned = @discussions.where(pinned: false).order('created_at desc')
    @discussions_pinned = @discussions.where(pinned: true).order('created_at desc')
  end

  def new
    @categories = Category.all
    @discussion = current_user.discussions.build
  end

  def edit
    @categories = Category.all
  end

  def create
    @discussion = current_user.discussions.build(discussion_params)

    if @discussion.save
      redirect_to @discussion, notice: 'Discussion was successfully created.'
    else
      # flash.now[:alert] = 'Couldn\'t save discussion: invalid params'
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @discussion.update(discussion_params)
      redirect_to @discussion, notice: 'Discussion was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
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

  def fetch_discussions
    @discussions = Discussion.all.includes(%i[user category rich_text_content replies]).order('created_at desc')
  end

  def discussion_params
    params.require(:discussion).permit(:title, :content, :category_id)
  end

  def authorize_discussion
    authorize(@discussion || Discussion)
  end
end
