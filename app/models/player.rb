class Player < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  belongs_to :original_role, :class_name => 'Role'
  belongs_to :current_role, :class_name => 'Role'
end
