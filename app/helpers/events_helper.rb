module EventsHelper
  def current_day
    Time.now.strftime('%A').downcase
  end
end
