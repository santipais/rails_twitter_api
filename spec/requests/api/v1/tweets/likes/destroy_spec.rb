# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /api/v1/tweets/:tweet_id/likes', type: :request do
  let(:user) { create(:user) }
  let(:tweet) { create(:tweet) }
  let(:tweet_id) { tweet.id }
  let(:headers) { auth_header(user) }
  let(:json_response) { json }

  subject { delete api_v1_tweet_likes_path(tweet_id), headers:, as: :json }

  context 'when the user is authenticated' do
    context 'when tweet_id is valid' do
      context 'when the user has liked the tweet' do
        before { create(:like, tweet: tweet, user: user) }

        it 'returns a no content response' do
          subject
          expect(response).to have_http_status(:no_content)
        end

        it 'deletes the like' do
          expect { subject }.to change(Like, :count).from(1).to(0)
        end

        it 'returns no content' do
          subject
          expect(response.body).to be_empty
        end
      end

      context 'when the user has not liked the tweet' do
        it 'returns a unprocessable entity response' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          subject
          expect(json_response[:errors]).to include('User has not liked this tweet')
        end

        it 'does not delete a like' do
          expect { subject }.not_to change(Like, :count)
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

      it 'does not delete a like' do
        expect { subject }.not_to change(Like, :count)
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
