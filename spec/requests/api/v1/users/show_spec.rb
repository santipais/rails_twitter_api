# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/v1/users/:id', type: :request do
  let(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:json_response) { json }

  subject { get api_v1_user_path(user_id) }

  context 'when the record exists' do
    it 'returns the user' do
      subject
      expect(json_response).not_to be_empty
      expect(json_response[:email]).to eq(user.email)
      expect(json_response[:username]).to eq(user.username)
      expect(json_response[:name]).to eq(user.full_name)
      expect(json_response[:birthdate]).to eq(user.birthdate.strftime('%d/%m/%Y'))
      expect(json_response[:website]).to eq(user.website)
      expect(json_response[:bio]).to eq(user.bio)
      expect(json_response[:date_joined]).to eq(user.created_at.strftime('%d/%m/%Y'))
    end

    it 'returns a successful response' do
      subject
      expect(response).to have_http_status(:success)
    end
  end

  context 'when the record does not exist' do
    let(:user_id) { 100 }

    it 'returns a not found response' do
      subject
      expect(response).to have_http_status(404)
    end

    it 'returns a not found message' do
      subject
      expect(json_response[:error]).to include('User not found.')
    end
  end
end
