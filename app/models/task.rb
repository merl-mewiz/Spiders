class Task < ApplicationRecord
  belongs_to :user
  belongs_to :status
  belongs_to :priority

  validates :title, presence: true, length: { minimum: 5, maximum: 255 }
end
