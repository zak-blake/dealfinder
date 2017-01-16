class UsersController < ApplicationController
  def show
    @owner = User.find(params[:id])

    @active_events = []
    @inactive_events = []
    day_events = Event.for_owner(@owner).happens_today

    day_events.each do |e|
      if e.ended?
        @inactive_events.push(e)
      else
        @active_events.push(e)
      end
    end

    @weekly_events = Event.for_owner(@owner).weekly_events
    @one_time_events = Event.for_owner(@owner).one_time_events
    @edit_mode = current_user && current_user.id == @owner.id
  end
end
