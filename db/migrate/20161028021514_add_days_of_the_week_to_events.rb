class AddDaysOfTheWeekToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :days_of_the_week, :integer
  end
end
