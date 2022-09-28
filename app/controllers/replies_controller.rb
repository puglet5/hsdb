# frozen_string_literal: true

class RepliesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_discussion, only: %i[create edit show update destroy]
  before_action :set_reply, only: %i[edit update destroy]

  def create
    @reply = @discussion.replies.create(params[:reply].permit(:reply, :discussion_id))
    @reply.user_id = current_user.id

    if @reply.save
      redirect_to @discussion
    else
      redirect_to @discussion, status: :unprocessable_entity
    end
  end

  def new; end

  def destroy
    @reply.destroy
    redirect_to @discussion, status: :see_other
  end

  def edit; end

  def update
    if @reply.update(reply_params)
      redirect_to @discussion
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show; end

  private

  def set_discussion
    @discussion = Discussion.find(params[:discussion_id])
  end

  def set_reply
    @reply = @discussion.replies.find(params[:id])
  end

  def reply_params
    params.require(:reply).permit(:reply)
  end
end
