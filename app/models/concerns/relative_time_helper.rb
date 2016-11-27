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
      str = "starts in #{hours_til_start}h"
      if minutes_til_start == 0
        str
      else
        str.concat " and #{minutes_til_start}m"
      end
    elsif (hours_til_start == 0) && minutes_til_start > 0
      if minutes_til_start >= 0
        "starts in #{minutes_til_start}m"
      else
        "started #{minutes_til_start*-1}m ago"
      end
    elsif hours_since_start == 0 && minutes_since_start < 60
      "started #{minutes_since_start}m ago"

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
          "ended #{minutes_since_end}m ago"
        else
          str = "ended #{hours_since_end}h"
          if minutes_til_end == 0
            str.concat " ago"
          else
            str.concat " and #{minutes_since_end}m ago"
          end
        end
      else
        #ongoing
        if (minutes_til_end < 0) && (hours_til_end >= 1)
          minutes_til_end = 60 + minutes_til_end
          hours_til_end -= 1
        end

        if hours_til_end == 0
          "#{minutes_til_end}m left"
        else
          str = "#{hours_til_end}h"
          if minutes_til_end == 0
            str.concat " left"
          else
            str.concat " and #{minutes_til_end}m left"
          end
        end
      end
    end
  end
end
