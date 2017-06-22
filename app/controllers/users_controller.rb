class UsersController < ApplicationController
  def show
    @owner = User.find(params[:id])

    unless @owner.status_approved? || current_user&.can_view_owner?(@owner)
      redirect_to root_path and return
    end

    if @owner.admin?
      redirect_to root_path and return
    end

    @active_events = []
    @inactive_events = []
    day_events = Event.for_owner(@owner).happens_today

    day_events.each do |e|
      e.ended? ? @inactive_events.push(e) : @active_events.push(e)
    end

    @weekly_events = Event.for_owner(@owner).weekly_events
    @one_time_events = Event.for_owner(@owner).one_time_events
    @edit_mode = current_user && current_user.id == @owner.id

    # admin panel info
    if @admin_view = current_user&.admin?
       @weekly_event_count = @owner.events.weekly.count.to_s
       @upcoming_one_time_count = @owner.events.one_time.not_past.count.to_s
       @past_one_time_count = @owner.events.one_time.past.count.to_s
    end
  end

  def index
    @admin_view = current_user&.admin?
    @owners = User.owner.approved

    @unapproved_owners = User.owner.unapproved if @admin_view
  end

  def update
    unless current_user&.admin?
      redirect_to root_path and return
    end

    owner = User.find(params[:id])
    if owner.update(admin_user_params)
      flash[:info] = "Updated"
    else
      flash[:alert] = "Update Failed"
    end

    redirect_to owner
  end

  private

  def admin_user_params
    params.require(:user).permit(:approved_status)
  end
end
