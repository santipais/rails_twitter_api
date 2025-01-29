# frozen_string_literal: true

class CreateFollows < ActiveRecord::Migration[7.0]
  def change
    create_table :follows do |t|
      t.references :user, null: false, foreign_key: true
      t.references :followed, null: false, foreign_key: { to_table: :users }

      t.index %i[user_id followed_id], unique: true

      t.timestamps
    end
  end
end
