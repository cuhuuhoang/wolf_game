class CreateWakeups < ActiveRecord::Migration
  def change
    create_table :wakeups do |t|
      t.datetime :sleep_until

      t.timestamps null: false
    end
  end
end
