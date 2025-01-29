# frozen_string_literal: true

class AddLikesCountToTweet < ActiveRecord::Migration[7.0]
  def up
    add_column :tweets, :likes_count, :integer, null: false, default: 0
    Tweet.pluck(:id).each do |id|
      Tweet.reset_counters(id, :likes)
    end
  end

  def down
    remove_column :tweets, :likes_count
  end
end
