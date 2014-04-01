class AddStateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :state, :integer, default: 0
    add_index :users, :state
  end
end
