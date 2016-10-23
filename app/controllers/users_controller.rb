class UsersController < ApplicationController
  def show
    @owner = User.find(params[:id])
    @events = @owner.events
  end

  def test_info
    render plain: "Hello Skylar! you've connected with rails!"
  end
end
