class EventsController < ApplicationController
  include  EventsHelper

  before_action :authenticate_user!, except: [:index, :show, :day]

  before_action :find_event, only: [:show, :edit, :update, :destroy]
  before_action :filter_content_owner, only: [ :edit, :update, :destroy]

  before_action :filter_dealer_or_admin, except: [:new, :index, :show, :day]
  before_action :set_edit_mode, only: [:show, :edit, :update, :destroy]

  def new
    @event = current_user.events.build
  end

  def create
    @event = current_user.events.build(event_params)

    @event.days_of_the_week = get_days_from_form

    if (@event.user == current_user) && @event.save
      flash[:success] = "Event Created"
      redirect_to @event
    else
      flash[:danger] = "Creation Failed"
      render 'new'
    end
  end

  def show
    @owner = @event.user
  end

  def edit
  end

  def update
    @event.assign_attributes(event_params)

    @event.days_of_the_week = get_days_from_form

    if (@event.user == current_user) && @event.save
      flash[:success] = "Update Successful"
      redirect_to @event
    else
      flash[:danger] = "Update Failed"
      render 'edit'
    end
  end

  def index
    @events_today = Event.order(:start_time).select{ |e| e.days.include? current_day }
  end

  def destroy
    @event.destroy
    flash[:success] = "Event Deleted"
    redirect_to user_show_path(current_user)
  end

  # App integration
  def day
    str = ""
    str.concat(event_to_pt(Event.first))
    str.concat(event_to_pt(Event.second))
    render plain: str
  end

  private

  def event_to_pt(event)
    divider = "~"
    str = ""
    str.concat(event.id.to_s).concat(divider).concat(
      event.name).concat(divider).concat(
      event.start_time.strftime("%I%M")).concat(divider).concat(
      event.end_time.strftime("%I%M")).concat(divider).concat(
      event.description).concat("*")
      return str
  end

  def event_params
    params.require(:event).permit(:name, :start_time, :end_time, :description, :days_of_the_week)
  end

  def find_event
    @event = Event.find(params[:id])
  end

  def filter_dealer_or_admin
    unless user_signed_in? && current_user.owner_or_admin?
      flash[:danger] = "Unauthorized"
      redirect_to root_path
    end
  end

  def filter_content_owner
    redirect_to root_path unless user_signed_in? && @event && @event.user == current_user
  end

  def set_edit_mode
    @edit_mode = user_signed_in? && @event.user == current_user
  end

  def get_days_from_form
    sum = 0
    [1, 2, 4, 8, 16, 32, 64].each do |index|
      box_name = "weekday#{index}"
      sum += params[box_name.to_sym][:select].to_i if params[box_name.to_sym][:select]
    end
    return sum
  end
end
