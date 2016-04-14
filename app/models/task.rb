class Task < ActiveRecord::Base
  belongs_to :game, dependent: :destroy
  order(created_at: :asc)
end
