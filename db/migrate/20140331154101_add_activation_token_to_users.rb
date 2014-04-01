class AddActivationTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :activation_token, :string
    add_column :users, :activation_token_sent_at, :datetime
    add_index :users, :activation_token
  end
end
