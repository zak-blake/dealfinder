class AddApprovedToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :approved_status, :integer, null: false, default: 0
  end
end
