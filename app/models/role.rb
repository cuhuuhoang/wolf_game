class Role < ActiveRecord::Base
  has_many :original_role_players, :class_name => 'Player', :foreign_key => 'original_role_id'
  has_many :current_role_players, :class_name => 'Player', :foreign_key => 'current_role_id'
end
