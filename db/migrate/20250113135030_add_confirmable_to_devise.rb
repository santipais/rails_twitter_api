# frozen_string_literal: true

class AddConfirmableToDevise < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :unconfirmed_email
      t.index :confirmation_token, unique: true
    end
  end
end
