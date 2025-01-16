# frozen_string_literal: true

class Tweet < ApplicationRecord
  belongs_to :user, counter_cache: true

  validates :content, presence: true, length: { maximum: 280 }
end
