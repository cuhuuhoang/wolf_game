class Player < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  belongs_to :game, dependent: :destroy
  belongs_to :original_role, :class_name => 'Role', dependent: :destroy
  belongs_to :current_role, :class_name => 'Role', dependent: :destroy
end
