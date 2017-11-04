class Event < ApplicationRecord

  default_scope -> { order(created_at: :desc).limit(10) }
end
