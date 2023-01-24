# frozen_string_literal: true

class DiscussionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_discussion, only: %i[show edit update destroy]
  before_action :fetch_discussions, only: %i[index show]
  before_action :fetch_categories, only: %i[edit update create new]
  before_action :authorize_discussion
  after_action :verify_authorized

  breadcrumb 'Home', :root
  breadcrumb 'Forum', :discussions, match: :exact

  def index
    @categories = Category.all.includes([:discussions]).order('created_at asc')
    @discussions_unpinned = @discussions.where(pinned: false).order('created_at desc')
    @discussions_pinned = @discussions.where(pinned: true).order('created_at desc')
  end

  def show
    @discussions_unpinned = @discussions.where(pinned: false).order('created_at desc')
    @discussions_pinned = @discussions.where(pinned: true).order('created_at desc')

    breadcrumb @discussion.title, @discussion, match: :exclusive
  end

  def new
    @discussion = current_user.discussions.build

    breadcrumb 'New Discussion', %i[new discussion], match: :exclusive
  end

  def edit
    breadcrumb @discussion.title, @discussion, match: :exclusive
    breadcrumb 'Edit', [:edit, @discussion], match: :exclusive
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

  def favorite
    @discussion = Discussion.find params[:id]
    authorize @discussion

    if current_user.favorited? @discussion
      current_user.unfavorite @discussion
    else
      current_user.favorite @discussion
    end
    redirect_to request.referer
  end

  private

  def set_discussion
    @discussion = Discussion.find(params[:id])
  end

  def fetch_categories
    @categories = Category.all
  end

  def fetch_discussions
    @discussions = Discussion.all.includes(%i[user category rich_text_content replies]).order('created_at desc')
  end

  def discussion_params
    params.require(:discussion).permit(
      :title,
      :content,
      :category_id,
      :lock_version
    )
  end

  def authorize_discussion
    authorize(@discussion || Discussion)
  end
end
