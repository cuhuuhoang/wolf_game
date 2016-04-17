class CreateLocks < ActiveRecord::Migration
  def change
    create_table :locks do |t|
      t.integer :time

      t.timestamps null: false
    end
  end
end
