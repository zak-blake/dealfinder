class EventsController < ApplicationController
  before_filter :authenticate_user!
  before_action :filter_dealer_or_admin, except: [:index]
  before_action :find_event, only: [:show, :edit, :update, :destroy]

  def new
    @event = current_user.events.build
  end

  def create
    @event = current_user.events.build(event_params)

    if @event.save
      flash[:success] = "Event Created"
      redirect_to @event
    else
      flash[:danger] = "Creation Failed"
      render 'new'
    end
  end

  # show all the events for a specific owner
  def owner_list
    @owner = User.find(params[:id])
    @events = @owner.events
  end

  def show
  end

  def edit
  end

  def update
    if @event.update(event_params)
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
    redirect_to owner_list_path(current_user.id)
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
end
