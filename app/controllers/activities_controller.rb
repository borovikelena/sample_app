class ActivitiesController < ApplicationController
  def index
    @activities = PublicActivity::Activity.order("created_at DESC").all

    respond_to do |format|
      format.html
    end
  end
end
