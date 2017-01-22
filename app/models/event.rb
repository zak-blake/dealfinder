class Event < ApplicationRecord
  include ActionView::Helpers::TextHelper
  include RelativeTimeHelper

  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :at_least_one_day
  validate :date_only_for_one_time
  validate :days_only_for_weekly
  validate :start_time_after_end_time

  belongs_to :owner, class_name: 'User', :foreign_key => 'user_id'

  enum event_type: { weekly: 0, one_time: 1 }

  scope :by_start_time, -> { order(:start_time) }
  scope :recent_first, -> { order(event_date: :desc) }

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

  def self.day_to_index(day)
    case day
    when "monday"
      0
    when "tuesday"
      1
    when "wednesday"
      2
    when "thursday"
      3
    when "friday"
      4
    when "saturday"
      5
    when "sunday"
      6
    end
  end

  def self.day_to_mask(day)
    case day
    when "monday"
      1
    when "tuesday"
      2
    when "wednesday"
      4
    when "thursday"
      8
    when "friday"
      16
    when "saturday"
      32
    when "sunday"
      64
    end
  end

  def self.today_or(day)
    current_day == day ? "today" : day
  end

  def self.current_day
    Time.zone.now.strftime('%A').downcase
  end

  def self.week_days_array
    WEEK_DAYS.map{|d| d.first}
  end

  def self.date_after_modifier(day)
    # day is assumed to be valid
    # returns the date modified by the dropdown
    todays_day = current_day
    return Date.today if day.nil? || day == todays_day

    current_index = day_to_index(todays_day)
    modifier_index = day_to_index(day)

    modifier_index += 7  if modifier_index < current_index

    date_shift = modifier_index - current_index

    Date.today + date_shift.days
  end

  def self.approved
    self.all.joins(:owner).where("users.approved_status = ?",
      User.approved_statuses[:status_approved])
  end

  def time_relative_to_now
    RelativeTimeHelper.time_relative_to_now(Time.zone.now, start_time, end_time)
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

  def self.every_monday
    self.weekly_events.where("days_of_the_week & 1 != 0")
  end

  def self.every_tuesday
    self.weekly_events.where("days_of_the_week & 2 != 0")
  end

  def self.every_wednesday
    self.weekly_events.where("days_of_the_week & 4 != 0")
  end

  def self.every_thursday
    self.weekly_events.where("days_of_the_week & 8 != 0")
  end

  def self.every_friday
    self.weekly_events.where("days_of_the_week & 16 != 0")
  end

  def self.every_saturday
    self.weekly_events.where("days_of_the_week & 32 != 0")
  end

  def self.every_sunday
    self.weekly_events.where("days_of_the_week & 64 != 0")
  end

  def self.every_day_number(day_number)
    return nil unless WEEK_DAYS.map{ |d| d.last }.include? day_number
    self.weekly_events.where("days_of_the_week & ? != 0", day_number)
  end

  def self.events_on_day(clean_day)
    # day dropdown parameter changes dates

    self.happens_on_date(date_after_modifier(clean_day))
  end

  # note: weekly events are not filtered out

  def self.past
    self.where("event_date < ?", Date.today)
  end

  def self.not_past
    self.where("event_date >= ? OR event_date IS NULL", Date.today)
  end

  def self.upcoming #does not include events today
    self.where("event_date > ? OR event_date IS NULL", Date.today)
  end

  def self.happens_on_date(date)
    day_number = Event.day_to_mask(date.strftime('%A').downcase)
    Event.where("event_date = ? OR (days_of_the_week & ? != 0)",
      date, day_number)
  end

  def self.happens_today
    self.happens_on_date(Date.today)
  end

  def self.for_owner(owner)
    self.where(owner: owner)
  end

  def happens_on_date?(date)
    if one_time? && (event_date == date)
      true
    elsif weekly? && (days_long.include? date.strftime('%A').downcase)
      true
    else
      false
    end
  end

  def date_is_today?
    return false unless one_time?
    event_date == Date.today
  end

  def date_is_tomorrow?
    return false unless one_time?
    event_date == Date.tomorrow
  end

  def ended?
    Time.zone.now.strftime("%H%M").to_i > end_time.strftime("%H%M").to_i
  end

  def pretty_time_range
    pretty_start_time + " - " + pretty_end_time
  end

  def pretty_start_time
    start_time.strftime("%I:%M %P").sub(/^[0:]*/,"")
  end

  def pretty_end_time
    end_time.strftime("%I:%M %P").sub(/^[0:]*/,"")
  end

  def days_short
    WEEK_DAYS.select { |d| (d.last & days_of_the_week) != 0 }.
      map{ |d| d.second }
  end

  def days_long
    WEEK_DAYS.select { |d| (d.last & days_of_the_week) != 0 }.
      map{ |d| d.first }
  end

  def pretty_active_time
    if weekly?
      days_as_string
    elsif date_is_today?
      "Only Today"
    elsif date_is_tomorrow?
      "Only Tomorrow"
    elsif one_time?
      event_date.strftime("%A %b %d")
    else
      ""
    end
  end

  def days_as_string
    case days_of_the_week
    when nil
      return ""
    when 127
      return "Everyday"
    when 96
      return "Weekends"
    when 31
      return "Weekdays"
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
    errors.add(
      :days_of_the_week, "requires at least one") if days_of_the_week == 0
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
