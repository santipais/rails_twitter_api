# frozen_string_literal: true

FactoryBot.define do
  factory :tweet do
    content { Faker::Lorem.sentence(word_count: 1..5) }
    user { build(:user) }
  end
end
