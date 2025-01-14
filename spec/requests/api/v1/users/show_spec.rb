# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/v1/users/:id', type: :request do
  let(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:json_response) { json }

  subject { get api_v1_user_path(user_id) }

  context 'when the record exists' do
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
      expect(json_response[:birthdate]).to eq(user.birthdate.strftime('%d/%m/%Y'))
      expect(json_response[:website]).to eq(user.website)
      expect(json_response[:bio]).to eq(user.bio)
      expect(json_response[:date_joined]).to eq(user.created_at.strftime('%d/%m/%Y'))
    end
  end

  context 'when the record does not exist' do
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
end
