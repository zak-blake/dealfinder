class UsersController < ApplicationController
  def show
    @owner = User.find(params[:id])
    @events = @owner.events
  end
end
