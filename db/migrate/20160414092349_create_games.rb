class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.boolean :is_current
      t.timestamps null: false
    end
  end
end
