class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.boolean :is_current, default: true
      t.timestamps null: false
      t.string :deck
    end
  end
end
