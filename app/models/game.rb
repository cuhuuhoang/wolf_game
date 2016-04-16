class Game < ActiveRecord::Base
  has_many :chatlogs, dependent: :destroy
  has_many :players, dependent: :destroy
  has_many :game_statuses, dependent: :destroy
end
