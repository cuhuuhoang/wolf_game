class Chatlog < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  belongs_to :game, dependent: :destroy

  order(created_at: :asc)
end
