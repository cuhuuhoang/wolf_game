class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|

      t.string :name
      t.text :description
      t.integer :role_id, unique:true


      t.timestamps null: false
    end
  end
end
