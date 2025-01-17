# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PUT /api/v1/users/:id', type: :request do
  let(:user) { create(:user, username: nil) }
  let(:user_id) { user.id }
  let(:username) { 'new_username' }
  let(:first_name) { 'New First Name' }
  let(:last_name) { 'New Last Name' }
  let(:birthdate) { '01/01/2000' }
  let(:website) { 'https://new_website.com' }
  let(:bio) { 'New bio' }
  let(:headers) { auth_header(user) }
  let(:json_response) { json }
  let(:params) do
    {
      user: {
        username:,
        first_name:,
        last_name:,
        birthdate:,
        website:,
        bio:
      }
    }
  end

  subject { put api_v1_user_path(user_id), params:, headers:, as: :json }

  context 'whent the params are correct' do
    context 'when the username was not already setted' do
      it 'returns a successful response' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'updates the user' do
        subject

        user.reload
        expect(username).to eq(user.username)
        expect(first_name).to eq(user.first_name)
        expect(last_name).to eq(user.last_name)
        expect(birthdate).to eq(user.birthdate.strftime('%d/%m/%Y'))
        expect(website).to eq(user.website)
        expect(bio).to eq(user.bio)
      end

      it 'returns the updated user' do
        subject

        user.reload
        expect(json_response[:id]).to eq(user.id)
        expect(json_response[:email]).to eq(user.email)
        expect(json_response[:username]).to eq(user.username)
        expect(json_response[:first_name]).to eq(user.first_name)
        expect(json_response[:last_name]).to eq(user.last_name)
        expect(json_response[:birthdate]).to eq(user.birthdate.strftime('%d/%m/%Y'))
        expect(json_response[:website]).to eq(user.website)
        expect(json_response[:bio]).to eq(user.bio)
        expect(json_response[:created_at]).to eq(user.created_at.to_s)
      end
    end

    context 'when the username was already setted' do
      let(:user) { create(:user) }

      it 'returns an bad request response' do
        subject
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error message' do
        subject
        expect(json_response[:errors][:username]).to include('has already been setted')
      end

      it 'does not update the user' do
        subject
        expect(user.reload.username).not_to eq(username)
      end
    end
  end

  context 'when the params are incorrect' do
    context 'when the user does not exist' do
      let(:user_id) { 'invalid_id' }

      it 'returns a not found response' do
        subject
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        subject
        expect(json_response[:error]).to include('Resource not found.')
      end
    end

    context 'when the updated user is not the current_user' do
      let(:current_user) { create(:user) }
      let(:headers) { auth_header(current_user) }

      it 'returns an unauthorized response' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        subject
        expect(json_response[:error]).to eq('Unauthorized.')
      end

      it 'does not update the user' do
        subject
        expect(user.reload.username).not_to eq(username)
      end
    end

    context 'when the birthdate is invalid' do
      let(:birthdate) { Time.current }

      it 'returns a bad request response' do
        subject
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error message' do
        subject
        expect(json_response[:errors][:birthdate]).to include('must be less than or equal to 18 years ago')
      end

      it 'does not update the user' do
        subject
        expect(user.reload.birthdate).not_to eq(birthdate)
      end
    end

    context 'when the website is invalid' do
      let(:website) { 'invalid_website' }

      it 'returns an bad request response' do
        subject
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error message' do
        subject
        expect(json_response[:errors][:website]).to include('is invalid')
      end

      it 'does not update the user' do
        subject
        expect(user.reload.website).not_to eq(website)
      end
    end

    context 'when the bio is invalid' do
      let(:bio) { Faker::Lorem.characters(number: 161) }

      it 'returns an bad request response' do
        subject
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error message' do
        subject
        expect(json_response[:errors][:bio]).to include('is too long (maximum is 160 characters)')
      end

      it 'does not update the user' do
        subject
        expect(user.reload.bio).not_to eq(bio)
      end
    end

    context 'when the username is incorrect' do
      context 'when the username is missing' do
        let(:username) { '' }

        it 'returns a bad request response' do
          subject
          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an error message' do
          subject
          expect(json_response[:errors][:username]).to include("can't be blank")
        end

        it 'does not update the user' do
          subject
          expect(user.reload.username).not_to eq(username)
        end
      end

      context 'when the username has already been taken' do
        before { create(:user, username:) }

        it 'returns a bad request response' do
          subject
          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an error message' do
          subject
          expect(json_response[:errors][:username]).to include('has already been taken')
        end

        it 'does not update the user' do
          subject
          expect(user.reload.username).not_to eq(username)
        end
      end

      context 'when the username is invalid' do
        let(:username) { 'invalid/username' }

        it 'returns a bad request response' do
          subject
          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an error message' do
          subject
          expect(json_response[:errors][:username]).to include('is invalid')
        end

        it 'does not update the user' do
          subject
          expect(user.reload.username).not_to eq(username)
        end
      end
    end
  end
end
