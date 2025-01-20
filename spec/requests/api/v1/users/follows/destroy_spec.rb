# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /api/v1/users/:user_id/follow', type: :request do
  let(:user) { create(:user) }
  let(:followed) { create(:user) }
  let(:followed_id) { followed.username }
  let(:headers) { auth_header(user) }
  let(:json_response) { json }

  subject { delete api_v1_user_follow_path(followed_id), headers:, as: :json }

  context 'when the user is authenticated' do
    context 'when the followed_id is valid' do
      context 'when the follow exists' do
        let!(:follow) { create(:follow, user:, followed:) }

        it 'returns a no content response' do
          subject
          expect(response).to have_http_status(:no_content)
        end

        it 'deletes the follow' do
          expect(follow).not_to be_nil
          expect { subject }.to change(user.reload.follows, :count).from(1).to(0)
          expect(user.reload.follows.find_by(id: user.id)).to be_nil
        end

        it 'returns no content' do
          subject
          expect(response.body).to be_empty
        end
      end

      context 'when the follow does not exists' do
        it 'returns a not found response' do
          subject
          expect(response).to have_http_status(:not_found)
        end

        it 'returns an error message' do
          subject
          expect(json_response[:error]).to include('Resource not found.')
        end

        it 'does deletes a follow' do
          expect { subject }.not_to change(user.follows, :count)
        end
      end
    end

    context 'when the followed_id is invalid' do
      let(:followed_id) { 'invalid_id' }

      it 'returns a not found response' do
        subject
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        subject
        expect(json_response[:error]).to include('Resource not found')
      end

      it 'does not deletes a follow' do
        expect { subject }.not_to change(user.follows, :count)
      end
    end
  end

  context 'when the user is not authenticated' do
    let(:headers) { {} }

    it 'returns an unauthorized response' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns an unauthorized message' do
      subject
      expect(json_response[:error]).to include('You need to sign in or sign up before continuing')
    end
  end
end
