module EventsHelper

  def day_link_list
    html = ''
    Event.week_days_array.each do |d|
      html += '<li>'
      html += link_to(
        Event.today_or(d), events_path(day: d), { class: "dropdown-item"})
      html += '</li>'
    end

    return html.html_safe
  end
end
