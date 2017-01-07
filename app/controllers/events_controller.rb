class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :day, :events_today]

  before_action :find_event, only: [:show, :edit, :update, :destroy]
  before_action :filter_content_owner, only: [ :edit, :update, :destroy]

  before_action :filter_dealer_or_admin,
    except: [:new, :index, :show, :day, :events_today]
  before_action :set_edit_mode, only: [:show, :edit, :update, :destroy]

  before_action :set_errors, only: [:new, :edit]

  def new
    @event = current_user.events.build(days_of_the_week: 0)
  end

  def create
    @event = current_user.events.build(event_params)

    @event.days_of_the_week = get_days_from_form

    if (@event.owner == current_user) && @event.save
      flash[:success] = "Event Created"
      redirect_to @event
    else
      @event.errors.full_messages.each do |e|
        flash[:danger] = e
      end
      render 'new'
    end
  end

  def show
    @owner = @event.owner
  end

  def edit
  end

  def update
    @event.assign_attributes(event_params)

    @event.days_of_the_week = get_days_from_form

    if (@event.owner == current_user) && @event.save
      flash[:success] = "Update Successful"
      redirect_to @event
    else
      @event.errors.full_messages.each do |e|
        flash[:danger] = e
      end
      render 'edit'
    end
  end

  def index
    day = params[:day]
    @selected_day = (Event.week_days_array.include? day) ?
      day : Event.current_day
    @view_is_today = Event.current_day == @selected_day

    @active_events = []
    @inactive_events = []
    day_events = Event.events_on_day(@selected_day).by_start_time

    if @view_is_today
      day_events.each do |e|
        if e.ended?
          @inactive_events.push(e)
        else
          @active_events.push(e)
        end
      end
    else
      @active_events = day_events
    end
  end

  def destroy
    @event.destroy
    flash[:success] = "Event Deleted"
    redirect_to user_show_path(current_user)
  end

  def api_events_today
    puts "sending data"
    render json: Event.by_start_time
    puts "sent!"
  end

  private

  def event_params
    params.require(:event).permit(
      :name, :start_time, :end_time, :description, :days_of_the_week,
      :event_date, :event_type)
  end

  def find_event
    @event = Event.find(params[:id])
  end

  def process_by_event_type
    date = nil if params[:weekly]
    days_of_the_week = nil if params[:"one-time"]
  end

  def set_errors
    @errors = params[:errors]
  end

  def filter_dealer_or_admin
    unless user_signed_in? && current_user.owner_or_admin?
      redirect_to root_path
    end
  end

  def filter_content_owner
    redirect_to root_path unless
      user_signed_in? && @event && @event.owner == current_user
  end

  def set_edit_mode
    @edit_mode = user_signed_in? && @event.owner == current_user
  end

  def get_days_from_form
    sum = 0
    [1, 2, 4, 8, 16, 32, 64].each do |index|
      box_name = "weekday#{index}"
      sum += params[box_name.to_sym][:select].to_i if
        params[box_name.to_sym][:select]
    end
    return sum
  end
end
