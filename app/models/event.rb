class Event < ApplicationRecord
  include EventsHelper

  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  validate :at_least_one_day

  belongs_to :owner, class_name: 'User', :foreign_key => 'user_id'

  default_scope { order(:start_time) }

  def self.events_today(day)
    self.where
  end

  def self.today_or(day)
    current_day == day ? "today" : day
  end

  def pretty_start_time
    start_time.strftime("%I:%M%p").sub(/^[0:]*/,"")
  end

  def pretty_end_time
    end_time.strftime("%I:%M%p").sub(/^[0:]*/,"")
  end

  def days_short
    WEEK_DAYS.select { |d| d.last & days_of_the_week != 0 }.map{ |d| d.second }
  end

  def days_long
    WEEK_DAYS.select { |d| d.last & days_of_the_week != 0 }.map{ |d| d.first }
  end

  def self.current_day
    Time.now.strftime('%A').downcase
  end

  def days_as_string
    return nil unless days_of_the_week
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

  WEEK_DAYS = [
    ["monday",    "M",  1],
    ["tuesday",   "T",  2],
    ["wednesday", "W",  4],
    ["thursday",  "Th", 8],
    ["friday",    "F",  16],
    ["saturday",  "Sa", 32],
    ["sunday",    "Su", 64]
  ]

  def self.week_days_array
    WEEK_DAYS.map{|d| d.first}
  end

  def at_least_one_day
    errors.add(:days_of_the_week, "at least one must be selected") if days_of_the_week == 0
  end
end
