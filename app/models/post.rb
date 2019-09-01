class Post < ApplicationRecord
  belongs_to :user
  scope :desc, -> { order(created_at: :desc) }

  # default_scope -> { order(created_at: :desc) }

  validates :content, presence: true, length: { maximum: 2000 }
end
