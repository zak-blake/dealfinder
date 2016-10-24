class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  before_action :find_event, only: [:show, :edit, :update, :destroy]
  before_action :filter_content_owner, only: [ :edit, :update, :destroy]

  before_action :filter_dealer_or_admin, except: [:new, :index, :show]
  before_action :set_edit_mode, only: [:show, :edit, :update, :destroy]

  def new
    @event = current_user.events.build
  end

  def create
    @event = current_user.events.build(event_params)

    if (event.user == current_user) && @event.save
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

    if (@event.user == current_user) && @event.save
      flash[:success] = "Update Successful"
      redirect_to @event
    else
      flash[:danger] = "Update Failed"
      render 'edit'
    end
  end

  def index
    @events = Event.all
  end

  def destroy
    @event.destroy
    flash[:success] = "Event Deleted"
    redirect_to user_show_path(current_user)
  end

  # App integration
  def day
    render plain: "No Data yet"
  end

  private

  def event_params
    params.require(:event).permit(:name, :start_time, :end_time, :description)
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
end
