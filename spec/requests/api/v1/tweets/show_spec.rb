# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/v1/tweets/:id', type: :request do
  let(:tweet) { create(:tweet) }
  let(:tweet_id) { tweet.id }
  let(:user) { create(:user) }
  let(:headers) { auth_header(user) }
  let(:json_response) { json }

  subject { get api_v1_tweet_path(tweet_id), headers:, as: :json }

  context 'when the user is authenticated' do
    context 'when the tweet_id is valid' do
      it 'returns a ok response' do
        subject
        expect(response).to have_http_status(:ok)
      end

      it 'returns the tweet' do
        subject

        expect(json_response.slice(:id, :content).as_json)
          .to eq(tweet.slice(:id, :content))
        expect(json_response[:posted_ago]).to eq(time_ago_in_words(tweet.created_at))

        expect(json_response[:user].slice(:id, :username, :first_name, :last_name).as_json)
          .to eq(tweet.user.slice(:id, :username, :first_name, :last_name))
      end
    end

    context 'when the tweet_id is invalid' do
      let(:tweet_id) { 'invalid_id' }

      it 'returns a not found response' do
        subject
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        subject
        expect(json_response[:error]).to include('Resource not found.')
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
      expect(json_response[:error]).to include('You need to sign in or sign up before continuing.')
    end
  end
end
