# frozen_string_literal: true

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'Recent Tweets' do
          table_for Tweet.includes(:user).order(created_at: :desc).first(5) do
            column 'User' do |tweet|
              tweet.user.username
            end
            column 'Content' do |tweet|
              link_to tweet.content, admin_tweet_path(tweet)
            end
            column 'Created At' do |tweet|
              tweet.created_at.strftime('%Y-%m-%d %H:%M:%S')
            end
          end
        end
      end

      column do
        panel 'Info' do
          para 'Welcome to ActiveAdmin.'
        end
      end
    end
  end
  # content
end
