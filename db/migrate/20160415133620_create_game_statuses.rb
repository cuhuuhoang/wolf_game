class CreateGameStatuses < ActiveRecord::Migration
  def change
    create_table :game_statuses do |t|
      t.string :name, unique:true
      t.string :value
      t.references :game, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
