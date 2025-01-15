# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :username, presence: true, length: { in: 2..20 }, uniqueness: { case_sensitive: false }, format: { with: /\A[a-zA-Z0-9_]*\z/ }, allow_blank: true,
                       if: -> { username.present? }
  validates :encrypted_password, presence: true
  validates :first_name, :last_name, presence: true, length: { minimum: 2 }
  validates :bio, length: { maximum: 160 }
  validates :website, format: { with: %r{https?://(www.)?[^\W]*\.com} }, allow_blank: true
  validates :birthdate, presence: true, comparison: { less_than_or_equal_to: 18.years.ago, message: :must_be_less_than_or_equal_to_18_years_ago }
  validate :username_change, if: :username_changed?

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def username_change
    return errors.add(:username, :already_setted) if username_was.present?

    validate_username_presence
  end

  def validate_username_presence
    errors.add(:username, :blank) if username.blank?
  end
end
