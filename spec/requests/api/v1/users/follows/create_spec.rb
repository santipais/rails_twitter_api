# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/v1/users/:user_id/follow', type: :request do
  let(:user) { create(:user) }
  let(:followed) { create(:user) }
  let(:followed_id) { followed.username }
  let(:headers) { auth_header(user) }
  let(:json_response) { json }

  subject { post api_v1_user_follow_path(followed_id), headers:, as: :json }

  context 'when the user is authenticated' do
    context 'when the followed_id is valid' do
      context 'when the user follows another user' do
        context 'when the user does not follow the followed user' do
          it 'returns a no content response' do
            subject
            expect(response).to have_http_status(:no_content)
          end

          it 'creates a new follow' do
            expect { subject }.to change(user.reload.follows, :count).from(0).to(1)
          end

          it 'creates a follow with the correct attributes' do
            subject

            follow = user.reload.follows.first
            expect(follow.id).not_to be_nil
            expect(follow.user).to eq(user)
            expect(follow.followed).to eq(followed)
          end

          it 'returns no content' do
            subject
            expect(response.body).to be_empty
          end
        end

        context 'when the user already follows the followed user' do
          before { user.follows.create!(followed: followed) }

          it 'returns a bad request response' do
            subject
            expect(response).to have_http_status(:bad_request)
          end

          it 'returns an error message' do
            subject
            expect(json_response[:errors][:user_id]).to include('has already followed this user')
          end

          it 'does not create a new follow' do
            expect { subject }.not_to change(user.reload.follows, :count)
          end
        end
      end

      context 'when the user follows himself' do
        let(:followed_id) { user.username }

        it 'returns a bad request response' do
          subject
          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an error message' do
          subject
          expect(json_response[:errors][:base]).to include('Users cannot follow themselves')
        end

        it 'does not create a new follow' do
          expect { subject }.not_to change(user.reload.follows, :count)
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

      it 'does not create a new follow' do
        expect { subject }.not_to change(user.reload.follows, :count)
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
