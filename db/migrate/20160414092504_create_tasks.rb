class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.integer :time_limit, default: -1
      t.integer :delay_time, default: 2
      t.integer :max_time, default: -1
      t.datetime :begin_task

      t.timestamps null: false
    end
  end
end
