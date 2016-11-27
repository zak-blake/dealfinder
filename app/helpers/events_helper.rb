module EventsHelper

  def day_link_list
    day_list = Event.week_days_array
    # rotate until todayu is first
    day_list.rotate! while day_list.first != Event.current_day

    html = ''
    day_list.each do |day|
      html += '<li>'
      html += link_to(
        Event.today_or(day), events_path(day: day), { class: "dropdown-item"})
      html += '</li>'
    end

    return html.html_safe
  end

  def days_of_the_week_checkboxes(event)
    html = ''
    index = 1

    Event::WEEK_DAYS.each do |day|
      html += label_tag(:weekday, class: "checkbox-inline") do
        concat check_box("weekday#{day.last}", "select",
          { checked: (event.days_of_the_week & index) != 0 }, day.last.to_s)
        concat day.first
      end

      index *= 2
    end

    return html.html_safe
  end

  def today_or_tomorrow_class(event)
    return "div-today".html_safe if event.date_is_today?
    return "div-tom".html_safe if event.date_is_tomorrow?
    ""
  end

  def active_events(events)
    return "<h2>it's dead</h2>".html_safe unless events.any?
    html = ''

    events.each do |e|
      html += render partial: 'shared/event_card', locals: {
        event: e,
        location: true,
        show_rel_time: true,
        compact: true
      }
    end

    return html.html_safe
  end

  def inactive_events(events, display_past_events)
    return nil unless events.any? && display_past_events

    html = '<center><h2 class="pretty-font">past</h2></center></row>'
    events.each do |e|
      html += render partial: 'shared/event_card', locals: {
        event: e,
        location: true,
        hide_desc: true,
        show_rel_time: true,
        compact: true
      }
    end

    return html.html_safe
  end

  def owner_links(event)
    "#{link_to "edit", edit_event_path(event)} /
      #{link_to "delete", event, :method => :delete, data:
        {confirm: "confirm delete: #{event.name}" }}".html_safe
  end
end
