class Event < ApplicationRecord
  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  validate :at_least_one_day

  belongs_to :user

  default_scope { order(:start_time) }

  def self.events_today(day)
    self.where
  end

  def days_short
    WEEK_DAYS.select { |d| d.last & days_of_the_week != 0 }.map{ |d| d.second }
  end

  def days_long
    WEEK_DAYS.select { |d| d.last & days_of_the_week != 0 }.map{ |d| d.first }
  end

  def days_as_string
    return nil unless days_of_the_week
    return "Everyday" if days_of_the_week == 127

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

  def at_least_one_day
    errors.add(:days_of_the_week, "at least one must be selected") if days_of_the_week == 0
  end
end
