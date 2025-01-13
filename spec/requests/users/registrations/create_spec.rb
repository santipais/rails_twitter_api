# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/v1/users', type: :request do
  let(:user) { build(:user) }
  let(:email) { user.email }
  let(:password) { user.password }
  let(:username) { user.username }
  let(:first_name) { user.first_name }
  let(:last_name) { user.last_name }
  let(:birthdate) { user.birthdate }
  let(:json_response) { json }
  let(:params) do
    {
      user: {
        email:,
        password:,
        username:,
        first_name:,
        last_name:,
        birthdate:
      }
    }
  end

  subject { post user_registration_path, params:, as: :json }

  context 'when the params are correct' do
    it 'returns a 201 Created successful response' do
      subject
      expect(response).to have_http_status(:created)
    end

    it 'creates a user' do
      expect { subject }.to change(User, :count).from(0).to(1)
    end

    it 'creates an unconfirmed user' do
      subject
      expect(User.last.confirmed?).to eq(false)
    end

    it 'returns a user' do
      subject
      expect(json_response[:id]).not_to be_nil
      expect(json_response[:email]).to eq(email)
      expect(json_response[:created_at]).to eq(User.last.created_at.to_s)
    end

    it 'sends a confirmation email' do
      expect { subject }.to change(ActionMailer::Base.deliveries, :count).from(0).to(1)
    end
  end

  context 'when the params are incorrect' do
    context 'when the email is incorrect' do
      context 'when the email is missing' do
        let(:email) { nil }

        it 'returns a unprocessable entity response' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          subject
          expect(json_response[:email]).to include("can't be blank")
        end

        it 'does not create a user' do
          expect { subject }.not_to change(User, :count)
        end
      end

      context 'when the email has already been taken' do
        before { user.save! }

        it 'returns a unprocessable entity response' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          subject
          expect(json_response[:email]).to include('has already been taken')
        end

        it 'does not create a user' do
          expect { subject }.not_to change(User, :count)
        end
      end

      context 'when the email is invalid' do
        let(:email) { 'invalid_email' }

        it 'returns a unprocessable entity response' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          subject
          expect(json_response[:email]).to include('is invalid')
        end

        it 'does not create a user' do
          expect { subject }.not_to change(User, :count)
        end
      end
    end

    context 'when the password is incorrect' do
      context 'when the password is missing' do
        let(:password) { nil }

        it 'returns a unprocessable entity response' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          subject
          expect(json_response[:password]).to include("can't be blank")
        end

        it 'does not create a user' do
          expect { subject }.not_to change(User, :count)
        end
      end

      context 'when the password is too short' do
        let(:password) { 'short' }

        it 'returns a unprocessable entity response' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          subject
          expect(json_response[:password]).to include('is too short (minimum is 6 characters)')
        end

        it 'does not create a user' do
          expect { subject }.not_to change(User, :count)
        end
      end
    end
  end
end
