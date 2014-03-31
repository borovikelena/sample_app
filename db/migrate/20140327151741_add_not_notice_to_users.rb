class AddNotNoticeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :not_notice, :boolean, default: false
  end
end
