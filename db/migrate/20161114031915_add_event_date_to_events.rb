class AddEventDateToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :event_date, :date
  end
end
