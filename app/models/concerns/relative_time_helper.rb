module RelativeTimeHelper
  def self.minute_difference(time1, time2)
    time2.strftime("%M").to_i - time1.strftime("%M").to_i
  end

  def self.hour_difference(time1, time2)
    time2.strftime("%H").to_i - time1.strftime("%H").to_i
  end

  def self.time_relative_to_now(now, start_time, end_time)
    hours_til_start = hour_difference(now, start_time)
    minutes_til_start = minute_difference(now, start_time)
    if (minutes_til_start < 0) && (hours_til_start >= 1)
      minutes_til_start = 60 + minutes_til_start
      hours_til_start -= 1
    end

    hours_since_start = -1*hours_til_start
    minutes_since_start = -1*minutes_til_start
    if (minutes_since_start < 0) && (hours_since_start >= 1)
      minutes_since_start = 60 + minutes_since_start
      hours_since_start -= 1
    end

    if hours_til_start >= 1
      str = "starts in #{pluralize(hours_til_start, 'hour')}"
      if minutes_til_start == 0
        str
      else
        str.concat " and #{pluralize(minutes_til_start, 'minute')}"
      end
    elsif (hours_til_start == 0) && minutes_til_start > 0
      if minutes_til_start >= 0
        "starts in #{pluralize(minutes_til_start, 'minute')}"
      else
        "started #{pluralize(minutes_til_start*-1, 'minute')} ago"
      end
    elsif hours_since_start == 0 && minutes_since_start < 60
      "started #{pluralize(minutes_since_start, 'minute')} ago"

    else
      hours_til_end = hour_difference(now, end_time)
      minutes_til_end = minute_difference(now, end_time)

      if hours_til_end < 0 || (hours_til_end == 0 && minutes_til_end < 0)
        #event ended
        hours_since_end = -1*hours_til_end
        minutes_since_end = -1*minutes_til_end

        if (minutes_since_end < 0) && (hours_since_end >= 1)
          minutes_since_end = 60 + minutes_since_end
          hours_since_end -= 1
        end

        if hours_since_end == 0
          "ended #{pluralize(minutes_since_end, 'minute')} ago"
        else
          str = "ended #{pluralize(hours_since_end, 'hour')}"
          if minutes_til_end == 0
            str.concat " ago"
          else
            str.concat " and #{pluralize(minutes_since_end, 'minute')} ago"
          end
        end
      else
        #ongoing
        if (minutes_til_end < 0) && (hours_til_end >= 1)
          minutes_til_end = 60 + minutes_til_end
          hours_til_end -= 1
        end

        if hours_til_end == 0
          "#{pluralize(minutes_til_end, 'minute')} left"
        else
          str = "#{pluralize(hours_til_end, 'hour')}"
          if minutes_til_end == 0
            str.concat " left"
          else
            str.concat " and #{pluralize(minutes_til_end, 'minute')} left"
          end
        end
      end
    end
  end

  def self.pluralize(count, str)
    ActionController::Base.helpers.pluralize(count, str)
  end
end
