# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to allow_value('test@example.com').for(:email) }
    it { is_expected.not_to allow_value('tes@t@example.com').for(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }

    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_length_of(:username).is_at_least(2).is_at_most(20) }
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
    it { is_expected.to allow_value('username').for(:username) }
    it { is_expected.not_to allow_value('user name').for(:username) }
    it { is_expected.not_to allow_value('invalid/username').for(:username) }

    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_length_of(:first_name).is_at_least(2) }

    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_length_of(:last_name).is_at_least(2) }

    it { is_expected.to validate_length_of(:bio).is_at_most(160) }

    it { is_expected.to allow_value('https://www.example.com').for(:website) }
    it { is_expected.to allow_value('http://www.example.com').for(:website) }
    it { is_expected.to allow_value('https://example.com').for(:website) }
    it { is_expected.to allow_value('http://example.com').for(:website) }
    it { is_expected.not_to allow_value('www.example.com').for(:website) }
    it { is_expected.not_to allow_value('example.com').for(:website) }

    it { is_expected.to validate_presence_of(:birthdate) }

    it 'validates that birthdate is at least 18 years ago' do
      user = build(:user, birthdate: 17.years.ago.to_date)
      expect(user).not_to be_valid
      expect(user.errors[:birthdate]).to include('must be less than or equal to 18 years ago')

      user.birthdate = 18.years.ago.to_date
      expect(user).to be_valid
    end
  end

  describe '#full_name' do
    subject { build(:user, first_name: 'John', last_name: 'Doe') }

    it 'returns the full name' do
      expect(subject.full_name).to eq('John Doe')
    end
  end
end
