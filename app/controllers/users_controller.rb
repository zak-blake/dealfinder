class UsersController < ApplicationController
  def show
    @owner = User.find(params[:id])
    @events = @owner.events.not_past
    @past_events = @owner.events.past.recent_first
    @edit_mode = current_user && current_user.id == @owner.id
  end
end
