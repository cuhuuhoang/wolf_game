class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.integer :time_limit
      t.references :game, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
