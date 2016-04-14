class Chatlog < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  order(created_at: :asc)
end
