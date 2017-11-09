class RemoveIsHumanFromEvents < ActiveRecord::Migration[5.1]
  def change
    remove_column :events, :is_human
  end
end
