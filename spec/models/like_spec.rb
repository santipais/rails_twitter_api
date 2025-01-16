# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Like, type: :model do
  subject { build(:like) }

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:tweet_id).with_message('has already liked this tweet') }

    context 'when user likes a tweet' do
      let(:user) { create(:user) }

      subject(:like) { build(:like, user: user) }

      it 'is valid' do
        expect(like.valid?).to eq(true)
      end

      context 'when user likes their own tweet' do
        let(:tweet) { create(:tweet, user:) }

        subject(:like) { build(:like, user:, tweet:) }

        it 'is invalid' do
          expect(like.valid?).to eq(false)
          expect(like.errors.full_messages).to include('Users cannot like their own tweets')
        end
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:tweet) }
  end
end
