# frozen_string_literal: true

class Tweet < ApplicationRecord
  belongs_to :user, counter_cache: true

  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  validates :content, presence: true, length: { maximum: 280 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[content user_id created_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    ['user']
  end
end
