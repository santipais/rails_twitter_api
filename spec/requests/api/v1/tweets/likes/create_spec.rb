# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/v1/tweets/:tweet_id/likes', type: :request do
  let(:user) { create(:user) }
  let(:tweet) { create(:tweet) }
  let(:tweet_id) { tweet.id }
  let(:headers) { auth_header(user) }
  let(:json_response) { json }

  subject { post api_v1_tweet_likes_path(tweet_id), headers:, as: :json }

  context 'when the user is authenticated' do
    context 'when tweet_id is valid' do
      context 'when the like is valid' do
        it 'returns a no content response' do
          subject
          expect(response).to have_http_status(:no_content)
        end

        it 'creates a new like' do
          expect { subject }.to change(tweet.reload.likes, :count).from(0).to(1)
        end

        it 'creates a like with the correct attributes' do
          subject

          like = tweet.reload.likes.last
          expect(like.id).not_to be_nil
          expect(like.tweet).to eq(tweet)
          expect(like.user).to eq(user)
        end

        it 'returns no content' do
          subject
          expect(response.body).to be_empty
        end
      end

      context 'when the like is invalid' do
        context 'when the user has already liked the tweet' do
          let!(:like) { create(:like, tweet:, user:) }

          it 'returns a bad_request response' do
            subject
            expect(response).to have_http_status(:bad_request)
          end

          it 'returns an error message' do
            subject
            expect(json_response[:errors][:user_id]).to include('has already liked this tweet')
          end

          it 'does not create a new like' do
            expect { subject }.not_to change(tweet.reload.likes, :count)
          end
        end

        context 'when the tweet is from the user' do
          let(:tweet) { create(:tweet, user: user) }

          it 'returns a bad_request response' do
            subject
            expect(response).to have_http_status(:bad_request)
          end

          it 'returns an error message' do
            subject
            expect(json_response[:errors][:base]).to include('Users cannot like their own tweets')
          end

          it 'does not create a new like' do
            expect { subject }.not_to change(tweet.reload.likes, :count)
          end
        end
      end
    end

    context 'when the tweet_id is invalid' do
      let(:tweet_id) { 0 }

      it 'returns a not found response' do
        subject
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        subject
        expect(json_response[:error]).to include('Resource not found')
      end

      it 'does not create a new like' do
        expect { subject }.not_to change(tweet.reload.likes, :count)
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
