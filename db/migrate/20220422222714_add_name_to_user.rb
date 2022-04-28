class AddNameToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :last_day, :datetime
    add_column :users, :streak, :integer, default: 0
  end
end
