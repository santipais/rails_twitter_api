# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Follow, type: :model do
  subject { build(:follow) }

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:followed_id).with_message('has already followed this user') }

    context 'when a user follows another user' do
      let(:user) { create(:user) }

      subject(:follow) { build(:follow, user: user) }

      it 'is valid' do
        expect(follow.valid?).to eq(true)
      end

      context 'when a user follows himself' do
        subject(:follow) { build(:follow, user: user, followed: user) }

        it 'is invalid' do
          expect(follow.valid?).to eq(false)
          expect(follow.errors.full_messages).to include('Users cannot follow themselves')
        end
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:followed).class_name('User') }
  end
end
