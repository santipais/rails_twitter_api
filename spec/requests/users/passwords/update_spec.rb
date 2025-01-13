# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PUT /api/v1/users/password', type: :request do
  let(:user) { create(:user) }
  let(:password) { 'new_password' }
  let!(:reset_password_token) { user.send_reset_password_instructions }
  let(:params) do
    {
      user: {
        reset_password_token:,
        password:
      }
    }
  end

  subject { put user_password_path, params:, as: :json }

  context 'when the params are correct' do
    it 'returns a successful response' do
      subject

      expect(response).to have_http_status(:no_content)
    end

    it 'revokes the user reset password token' do
      expect { subject }.to change { user.reload.reset_password_token }.to(nil)
    end

    it 'updates the password' do
      expect { subject }.to change { user.reload.valid_password?(password) }.from(false).to(true)
    end
  end

  context 'when the params are incorrect' do
    context 'when the reset password token is invalid' do
      let(:reset_password_token) { 'wrong_token' }

      it 'returns an error response' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        subject
        expect(json[:errors][:reset_password_token]).to eq(['is invalid'])
      end

      it 'does not revoke the user reset password token' do
        expect { subject }.not_to change(user.reload, :reset_password_token)
      end

      it 'does not update the password' do
        expect { subject }.not_to change(user.reload, :encrypted_password)
      end
    end

    context 'when the password is missing' do
      let(:password) { nil }

      it 'returns an error response' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        subject
        expect(json[:errors][:password]).to eq(["can't be blank"])
      end

      it 'does not revoke the user reset password token' do
        expect { subject }.not_to change(user.reload, :reset_password_token)
      end

      it 'does not update the password' do
        expect { subject }.not_to change(user.reload, :encrypted_password)
      end
    end

    context 'when the password is too short' do
      let(:password) { 'short' }

      it 'returns an error response' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        subject
        expect(json[:errors][:password]).to eq(['is too short (minimum is 6 characters)'])
      end

      it 'does not revoke the user reset password token' do
        expect { subject }.not_to change(user.reload, :reset_password_token)
      end

      it 'does not update the password' do
        expect { subject }.not_to change(user.reload, :encrypted_password)
      end
    end
  end
end
