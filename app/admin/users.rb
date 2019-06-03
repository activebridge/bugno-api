# frozen_string_literal: true

ActiveAdmin.register User do
  permit_params :provider, :uid, :encrypted_password, :reset_password_token,
                :reset_password_sent_at, :allow_password_change,
                :remember_created_at, :sign_in_count, :current_sign_in_at,
                :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip,
                :confirmation_token, :confirmed_at, :confirmation_sent_at,
                :unconfirmed_email, :name, :nickname, :image, :email, :tokens
end
