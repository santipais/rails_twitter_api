# frozen_string_literal: true

ActiveAdmin.register User do
  permit_params :email, :username, :birthdate, :first_name, :last_name, :password, :password_confirmation

  filter :content
  filter :user

  index do
    selectable_column
    id_column
    column :email
    column :username
    column :full_name
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :email
      row :username
      row :birthdate
      row :first_name
      row :last_name
      row :bio
      row :webiste
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :username
      f.input :birthdate, as: :date_select, start_year: 1900, end_year: Time.current.year
      f.input :first_name
      f.input :last_name
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end
    end
    f.actions
  end

  before_create do |user|
    user.confirmed_at = Time.current
  end
end
