class Game < ActiveRecord::Base
  has_many :chatlogs
  has_many :players
  has_many :tasks
end
