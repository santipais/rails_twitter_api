# frozen_string_literal: true

class Tweet < ApplicationRecord
  belongs_to :user, counter_cache: true

  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  validates :content, presence: true, length: { maximum: 280 }
end
