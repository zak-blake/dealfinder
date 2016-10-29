class Event < ApplicationRecord
  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :description, presence: true

  validate :at_least_one_day

  belongs_to :user

  default_scope { order(:start_time) }

  def self.events_today(day)
    self.where
  end

  def days
    WEEK_DAYS.select { |d| d.second & days_of_the_week != 0 }.map{ |d| d.first }
  end

  def days_as_string
    return nil unless days_of_the_week
    return "every day" if days_of_the_week == 127

    str = ""
    WEEK_DAYS.each do |d|
      str.concat(d.first).concat(" ") if (d.second & days_of_the_week != 0)
    end
    str
  end

  WEEK_DAYS = [
    ["monday", 1],
    ["tuesday", 2],
    ["wednesday", 4],
    ["thursday", 8],
    ["friday", 16],
    ["saturday", 32],
    ["sunday", 64]
  ]

  def at_least_one_day
    errors.add(:days_of_the_week, "at least one must be selected") if days_of_the_week == 0
  end
end
