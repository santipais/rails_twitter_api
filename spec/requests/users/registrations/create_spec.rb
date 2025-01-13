# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/v1/users', type: :request do
  let(:user_attributes) { attributes_for(:user) }
  let(:email) { user_attributes[:email] }
  let(:password) { user_attributes[:password] }
  let(:username) { user_attributes[:username] }
  let(:first_name) { user_attributes[:first_name] }
  let(:last_name) { user_attributes[:last_name] }
  let(:birthdate) { user_attributes[:birthdate] }
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
  let(:user) { User.last }

  subject { post user_registration_path, params:, as: :json }

  context 'when the params are correct' do
    it 'returns a 201 Created successful response' do
      subject
      expect(response).to have_http_status(:created)
    end

    it 'creates a user' do
      expect { subject }.to change(User, :count).from(0).to(1)
    end

    it 'creates a user with the correct attributes' do
      subject
      expect(user.email).to eq(email)
      expect(user.username).to eq(username)
      expect(user.first_name).to eq(first_name)
      expect(user.last_name).to eq(last_name)
      expect(user.birthdate).to eq(birthdate)
    end

    it 'creates an unconfirmed user' do
      subject
      expect(user.confirmed?).to eq(false)
    end

    it 'returns a user' do
      subject
      expect(json_response[:id]).to eq(user.id)
      expect(json_response[:email]).to eq(email)
      expect(json_response[:username]).to eq(username)
      expect(json_response[:first_name]).to eq(first_name)
      expect(json_response[:last_name]).to eq(last_name)
      expect(json_response[:created_at]).to eq(user.created_at.to_s)
    end

    it 'sends a confirmation email' do
      expect { subject }.to change(ActionMailer::Base.deliveries, :count).from(0).to(1)
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
        before { create(:user, email:) }

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

    context 'when the username is incorrect' do
      context 'when the username is missing' do
        let(:username) { nil }

        it 'returns a unprocessable entity response' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          subject
          expect(json_response[:username]).to include("can't be blank")
        end

        it 'does not create a user' do
          expect { subject }.not_to change(User, :count)
        end
      end

      context 'when the username has already been taken' do
        before { create(:user, username:) }

        it 'returns a unprocessable entity response' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          subject
          expect(json_response[:username]).to include('has already been taken')
        end

        it 'does not create a user' do
          expect { subject }.not_to change(User, :count)
        end
      end

      context 'when the username is invalid' do
        let(:username) { 'invalid/username' }

        it 'returns a unprocessable entity response' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          subject
          expect(json_response[:username]).to include('is invalid')
        end

        it 'does not create a user' do
          expect { subject }.not_to change(User, :count)
        end
      end
    end

    context 'when the first name is incorrect' do
      context 'when the first name is missing' do
        let(:first_name) { nil }

        it 'returns a unprocessable entity response' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          subject
          expect(json_response[:first_name]).to include("can't be blank")
        end

        it 'does not create a user' do
          expect { subject }.not_to change(User, :count)
        end
      end

      context 'when the first name is too short' do
        let(:first_name) { 'a' }

        it 'returns a unprocessable entity response' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          subject
          expect(json_response[:first_name]).to include('is too short (minimum is 2 characters)')
        end

        it 'does not create a user' do
          expect { subject }.not_to change(User, :count)
        end
      end
    end

    context 'when the last name is incorrect' do
      context 'when the last name is missing' do
        let(:last_name) { nil }

        it 'returns a unprocessable entity response' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          subject
          expect(json_response[:last_name]).to include("can't be blank")
        end

        it 'does not create a user' do
          expect { subject }.not_to change(User, :count)
        end
      end

      context 'when the last name is too short' do
        let(:last_name) { 'a' }

        it 'returns a unprocessable entity response' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          subject
          expect(json_response[:last_name]).to include('is too short (minimum is 2 characters)')
        end

        it 'does not create a user' do
          expect { subject }.not_to change(User, :count)
        end
      end
    end

    context 'when the birthdate is incorrect' do
      context 'when the birthdate is missing' do
        let(:birthdate) { nil }

        it 'returns a unprocessable entity response' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          subject
          expect(json_response[:birthdate]).to include("can't be blank")
        end

        it 'does not create a user' do
          expect { subject }.not_to change(User, :count)
        end
      end

      context 'when the birthdate is too young' do
        let(:birthdate) { Time.current }

        it 'returns a unprocessable entity response' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          subject
          expect(json_response[:birthdate]).to include('must be less than or equal to 18 years ago')
        end

        it 'does not create a user' do
          expect { subject }.not_to change(User, :count)
        end
      end
    end
  end
end
