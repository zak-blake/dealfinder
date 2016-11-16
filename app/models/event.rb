class Event < ApplicationRecord
  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :at_least_one_day
  validate :date_only_for_one_time
  validate :days_only_for_weekly
  validate :start_time_after_end_time

  belongs_to :owner, class_name: 'User', :foreign_key => 'user_id'

  enum event_type: { weekly: 0, one_time: 1 }

  default_scope { order(:start_time) }

  before_validation(on: [:create, :update]) do
    self.event_date = nil if weekly?
    self.days_of_the_week = nil if one_time?
  end

  WEEK_DAYS = [
    ["monday",    "M",  1],
    ["tuesday",   "T",  2],
    ["wednesday", "W",  4],
    ["thursday",  "Th", 8],
    ["friday",    "F",  16],
    ["saturday",  "Sa", 32],
    ["sunday",    "Su", 64]
  ]

  def self.today_or(day)
    current_day == day ? "today" : day
  end

  def self.current_day
    Time.zone.now.strftime('%A').downcase
  end

  def self.week_days_array
    WEEK_DAYS.map{|d| d.first}
  end

  def self.type_name_array
    [[:weekly, "weekly"], [:one_time, "one-time"]]
  end

  def self.one_time_events
    self.where(event_type: "one_time")
  end

  def self.weekly_events
    self.where(event_type: "weekly")
  end

  def self.events_today(day)
    events = self.select{ |e| e.happening_today? day }

    # only filter past events today
    events.reject!{ |e| e.ended? } if current_day == day
    events
  end

  def happening_today?(day)
    if weekly?
      return true if days_long.include? day
    elsif one_time?
      return true if event_date.today?
    end
    false
  end

  def ended?
    et = end_time.strftime("%H%M").to_i
    now = Time.zone.now.strftime("%H%M").to_i

    now > et
  end

  def pretty_start_time
    start_time.strftime("%I:%M%p").sub(/^[0:]*/,"")
  end

  def pretty_end_time
    end_time.strftime("%I:%M%p").sub(/^[0:]*/,"")
  end

  def days_short
    WEEK_DAYS.select { |d| (d.last & days_of_the_week) != 0 }.map{ |d| d.second }
  end

  def days_long
    WEEK_DAYS.select { |d| (d.last & days_of_the_week) != 0 }.map{ |d| d.first }
  end

  def day_or_dates
    return days_as_string if weekly?
    return event_date.strftime("%A %b %d") if one_time?
    ""
  end

  def days_as_string
    return "" unless days_of_the_week
    return "Everyday" if days_of_the_week == 127

    # single day
    case days_of_the_week
    when 1
      return "Mondays"
    when 2
      return "Tuesdays"
    when 4
      return "Wednesdays"
    when 8
      return "Thursdays"
    when 16
      return "Fridays"
    when 32
      return "Saturdays"
    when 64
      return "Sundays"
    end

    # multiple days
    str = ""
    WEEK_DAYS.each do |d|
      str.concat(d.second).concat(" ") if (d.last & days_of_the_week != 0)
    end
    str
  end

  private

  def at_least_one_day
    errors.add(:days_of_the_week, "requires at least one") if days_of_the_week == 0
  end

  def date_only_for_one_time
    if weekly? && !event_date.nil?
      errors.add(:event_date, "is only for one time events")
    elsif one_time? && event_date.nil?
      errors.add(:event_date, "required for one time events")
    end
  end

  def days_only_for_weekly
    if weekly? && days_of_the_week.nil?
      errors.add(:days_of_the_week, "is required for weekly events")
    elsif one_time? && !days_of_the_week.nil?
      errors.add(:days_of_the_week, "is only for weekly events")
    end
  end

  def start_time_after_end_time
    errors.add("event", "must end after is has started") if
      start_time && end_time &&
      end_time.strftime("%H%M").to_i <= start_time.strftime("%H%M").to_i
  end
end
