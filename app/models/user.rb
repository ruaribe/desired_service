class User < ApplicationRecord
  attr_accessor :remember_token

  has_one_attached :profile_picture
  attribute :new_profile_picture
  attribute :remove_profile_picture, :boolean

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: 'post'

  before_save do
    email.downcase!
    if new_profile_picture
      profile_picture.attach(new_profile_picture)
    elsif remove_profile_picture
      profile_picture.purge
    end
  end

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  validate if: :new_profile_picture do
    if new_profile_picture.respond_to?(:content_type)
      unless new_profile_picture.content_type.in?(ALLOWD_CONTENT_TYPES)
        errors.add(:new_profile_picture, :invalid_image_type)
      end
    else
      errors.add(:new_profile_picture, :invalid)
    end
  end

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end


end
