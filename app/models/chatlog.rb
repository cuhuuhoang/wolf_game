class Chatlog < ActiveRecord::Base
  belongs_to :user

  order(created_at: :asc)
end
