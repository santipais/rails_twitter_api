# frozen_string_literal: true

class AddFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :username
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :website
      t.string :bio
      t.datetime :birthdate, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.index :username
    end
  end
end
