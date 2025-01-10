# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/v1/me', type: :request do
  let(:user) { create(:user) }
  let(:headers) { auth_header(user) }

  subject { get api_v1_me_path, headers: }

  context 'when the credentials are correct' do
    it 'returns a successful response' do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'returns the user' do
      subject
      expect(json[:email]).to eq(user.email)
    end
  end

  context 'when the credentials are incorrect' do
    let(:headers) { {} }

    it 'returns an unauthorized response' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
