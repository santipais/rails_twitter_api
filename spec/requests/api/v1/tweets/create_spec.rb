# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/v1/tweets', type: :request do
  let(:user) { create(:user) }
  let(:content) { 'New Tweet.' }
  let(:headers) { auth_header(user) }
  let(:json_response) { json }
  let(:params) do
    {
      tweet: {
        content:
      }
    }
  end
  let(:tweet) { Tweet.last }

  subject { post api_v1_tweets_path, headers:, params:, as: :json }

  context 'when the params are correct' do
    context 'when the user is authenticated' do
      it 'returns a successful response' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'creates a new tweet' do
        expect { subject }.to change(Tweet, :count).from(0).to(1)
      end

      it 'creates a tweet with the correct attributes' do
        subject
        expect(tweet.id).not_to be_nil
        expect(tweet.content).to eq(content)
        expect(tweet.user).to eq(user)
      end

      it 'returns the tweet' do
        subject

        expect(json_response[:id]).to eq(tweet.id)
        expect(json_response[:content]).to eq(content)
        expect(json_response[:posted_ago]).not_to be_nil
        expect(json_response[:likes_count]).to eq(0)
        expect(json_response[:user][:id]).to eq(user.id)
      end

      it 'updates the user tweets count' do
        expect { subject }.to change { user.reload.tweets_count }.from(0).to(1)
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

  context 'when the params are incorrect' do
    context 'when the content is missing' do
      let(:content) { nil }

      it 'returns a bad request response' do
        subject
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error message' do
        subject
        expect(json_response[:errors][:content]).to include("can't be blank")
      end

      it 'does not create a new tweet' do
        expect { subject }.not_to change(Tweet, :count)
      end
    end

    context 'when the content is too long' do
      let(:content) { 'a' * 281 }

      it 'returns a bad request response' do
        subject
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error message' do
        subject
        expect(json_response[:errors][:content]).to include('is too long (maximum is 280 characters)')
      end

      it 'does not create a new tweet' do
        expect { subject }.not_to change(Tweet, :count)
      end
    end
  end
end
