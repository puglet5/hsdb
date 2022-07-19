# frozen_string_literal: true

class RepliesController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_reply, only: %i[edit update show destroy]
  before_action :set_discussion, only: %i[create edit show update destroy]

  def create
    @reply = @discussion.replies.create(params[:reply].permit(:reply, :discussion_id))
    @reply.user_id = current_user.id

    if @reply.save
      redirect_to discussion_path(@discussion)
    else
      redirect_to discussion_path(@discussion), notice: 'Reply wasn\'t saved. Please try again.'
    end
  end

  def new; end

  def destroy
    @reply = @discussion.replies.find(params[:id])
    @reply.destroy
    redirect_to discussion_path(@discussion), status: :see_other
  end

  def edit
    @discussion = Discussion.find(params[:discussion_id])
    @reply = @discussion.replies.find(params[:id])
  end

  def update
    @reply = @discussion.replies.find(params[:id])
    if @reply.update(reply_params)
      redirect_to discussion_path(@discussion)
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
    @reply = Reply.find(params[:id])
  end

  def reply_params
    params.require(:reply).permit(:reply)
  end
end
