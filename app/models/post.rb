class Post < ApplicationRecord
  belongs_to :user

  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: 'user'
  has_many :images, class_name: 'PostImage', dependent: :destroy

  scope :desc, -> { order(created_at: :desc) }

  validates :content, presence: true, length: { maximum: 2000 }

end
