# frozen_string_literal: true

class AddFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :username, unique: true, null: false, default: ''
      t.string :first_name, null: false, default: ''
      t.string :last_name, null: false, default: ''
      t.string :website
      t.string :bio
      t.datetime :birthdate, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.index :username, unique: true
    end
  end
end
