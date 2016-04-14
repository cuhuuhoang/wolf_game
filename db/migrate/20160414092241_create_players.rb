class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.references :user, index: true, foreign_key: true
      t.references :game, index: true, foreign_key: true
      t.string :char
      t.string :vote
      t.integer :original_role_id, :class_name => 'Role', index: true, foreign_key: true
      t.integer :current_role_id, :class_name => 'Role', index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
