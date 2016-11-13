module EventsHelper

  def day_link_list
    html = ''
    Event.week_days_array.each do |day|
      html += '<li>'
      html += link_to(
        Event.today_or(day), events_path(day: day), { class: "dropdown-item"})
      html += '</li>'
    end

    return html.html_safe
  end
end
