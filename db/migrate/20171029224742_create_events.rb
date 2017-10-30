class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.boolean :is_human
      t.boolean :walked_in
      t.string :photo

      t.timestamps
    end
  end
end
