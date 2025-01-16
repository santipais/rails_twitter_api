# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /api/v1/users/sign_out', type: :request do
  let(:user) { create(:user) }
  let(:headers) { auth_header(user) }
  let(:json_response) { json }

  subject { delete destroy_user_session_path, headers:, as: :json }

  context 'when the user is signed in' do
    it 'returns a successful response' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'returns the user' do
      subject
      expect(json_response[:id]).to eq(user.id)
      expect(json_response[:email]).to eq(user.email)
      expect(json_response[:username]).to eq(user.username)
      expect(json_response[:first_name]).to eq(user.first_name)
      expect(json_response[:last_name]).to eq(user.last_name)
      expect(json_response[:bio]).to be_nil
      expect(json_response[:website]).to be_nil
      expect(json_response[:birthdate]).to eq(user.birthdate.strftime('%d/%m/%Y'))
      expect(json_response[:created_at]).to eq(user.created_at.to_s)
    end

    it 'invalidates the existing JWT' do
      expect { subject }.to(change { user.reload.jti })
    end
  end

  context 'when the user is not signed in' do
    let(:headers) { {} }

    it 'returns an not found response' do
      subject
      expect(response).to have_http_status(:not_found)
    end

    it 'returns an error message' do
      subject
      expect(json_response[:message]).to eq('No active session')
    end
  end
end
