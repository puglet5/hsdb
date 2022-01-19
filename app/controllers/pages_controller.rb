# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @activities = PublicActivity::Activity.all.includes([:trackable, :owner]).order('created_at DESC')
  end

  def about; end

  def welcome; end

  def contact; end
end
