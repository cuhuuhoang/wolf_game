class Task < ActiveRecord::Base
  belongs_to :game
  order(created_at: :asc)
end
