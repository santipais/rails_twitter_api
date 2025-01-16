# frozen_string_literal: true

FactoryBot.define do
  factory :tweet do
    content { Faker::Books::Dune.quote.truncate(280) }
    user { build(:user) }
  end
end
