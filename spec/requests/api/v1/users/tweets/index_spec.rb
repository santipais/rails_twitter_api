# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/v1/users/:user_id/tweets', type: :request do
  include ActionView::Helpers::DateHelper

  let(:user) { create(:user) }
  let(:user_id) { user.username }
  let(:current_user) { create(:user) }
  let(:headers) { auth_header(current_user) }
  let(:json_response) { json }

  subject { get api_v1_user_tweets_path(user_id), headers:, as: :json }

  context 'when the user is authenticated' do
    context 'when the user_id is valid' do
      context 'when the user has tweets' do
        let!(:tweets) { create_list(:tweet, 2, user: user).sort_by(&:created_at).reverse }

        it 'returns a ok response' do
          subject
          expect(response).to have_http_status(:ok)
        end

        it 'returns the list of tweets' do
          subject

          expect(json_response.size).to eq(tweets.size)
          tweets.each_with_index do |tweet, i|
            expect(json_response[i][:id]).to eq(tweet.id)
            expect(json_response[i][:content]).to eq(tweet.content)
            expect(json_response[i][:posted_ago]).to eq(time_ago_in_words(tweet.created_at))
            expect(json_response[i][:likes_count]).to eq(tweet.likes_count)
          end
        end
      end

      context 'when the user has no tweets' do
        it 'returns a ok response' do
          subject
          expect(response).to have_http_status(:ok)
        end

        it 'returns an empty list' do
          subject
          expect(json_response).to eq([])
        end
      end
    end

    context 'when the user_id is invalid' do
      let(:user_id) { 'invalid_id' }

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
