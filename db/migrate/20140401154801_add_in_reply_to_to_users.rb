class AddInReplyToToUsers < ActiveRecord::Migration
  def change
    add_column :users, :in_reply_to, :integer
  end
end
