# frozen_string_literal: true

ActiveAdmin.register Tweet do
  permit_params :content, :user_id

  includes :user

  filter :content
  filter :user

  config.sort_order = 'created_at_desc'

  index do
    selectable_column
    id_column
    column :content
    column :user
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :user
      f.input :content
    end
    f.actions
  end
end
