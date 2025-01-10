# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /api/v1/users/sign_out', type: :request do
  let(:user) { create(:user) }
  let(:headers) { auth_header(user) }

  subject { delete destroy_user_session_path, headers:, as: :json }

  context 'when the user is signed in' do
    it 'returns a successful response' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'returns the user' do
      subject
      expect(json[:id]).not_to be_nil
      expect(json[:email]).to eq(user.email)
      expect(json[:created_at]).to eq(User.last.created_at.to_s)
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
      expect(json[:message]).to eq('No active session')
    end
  end
end
