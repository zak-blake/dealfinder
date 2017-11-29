class ApiController < ApplicationController

  def events_today

    days_deal = Event.happens_on_date(Date.today + params[:day].to_i).
      by_start_time.each_with_index.map{ |e, i|
        {
          key: i,
          name: e.name,
          relative_time: e.time_relative_to_now,
          # days_of_the_week: e.days_of_the_week,
          description: e.description,
          start_time: e.start_time,
          end_time: e.end_time,
          owner: e.owner.name,
          event_date: e.event_date
        }
      }

    render json: days_deal
  end

  def users_index

    all_users = User.all.each_with_index.map{ |u, i|
      {
        key: i,
        name: u.name
      }
    }

    render json: all_users


  end

  private

end
