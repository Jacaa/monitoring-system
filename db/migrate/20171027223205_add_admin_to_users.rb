class AddAdminToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admin, :boolean, default: false
    add_column :users, :send_notification, :boolean, default: false
    add_column :users, :save_photo, :boolean, default: false
  end
end
