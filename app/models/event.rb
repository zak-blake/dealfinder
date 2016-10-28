class Event < ApplicationRecord
  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :description, presence: true

  belongs_to :user

  WEEK_DAYS = [
    ["monday", 1],
    ["tuesday", 2],
    ["wednesday", 4],
    ["thrusday", 8],
    ["friday", 16],
    ["saturday", 32],
    ["sunday", 64]
  ]
end
