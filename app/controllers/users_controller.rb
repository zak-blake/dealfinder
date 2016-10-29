class UsersController < ApplicationController
  def show
    @owner = User.find(params[:id])
    @events = @owner.events.order(:start_time)
    @edit_mode = current_user && current_user.id == @owner.id
  end
end
