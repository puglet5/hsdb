class DiscussionsController < ApplicationController
  before_action :set_discussion, only: [:show, :edit, :update, :destroy]
  # access all: [:index, :show, :new, :edit, :create, :update, :destroy], user: :all

  # GET /discussions
  def index
    @discussions = Discussion.all
  end

  # GET /discussions/1
  def show
  end

  # GET /discussions/new
  def new
    @discussion = Discussion.new
  end

  # GET /discussions/1/edit
  def edit
  end

  # POST /discussions
  def create
    @discussion = Discussion.new(discussion_params)

    if @discussion.save
      redirect_to @discussion, notice: "Discussion was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /discussions/1
  def update
    if @discussion.update(discussion_params)
      redirect_to @discussion, notice: "Discussion was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /discussions/1
  def destroy
    @discussion.destroy
    redirect_to discussions_url, notice: "Discussion was successfully destroyed."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_discussion
    @discussion = Discussion.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def discussion_params
    params.require(:discussion).permit(:title, :content)
  end
end
