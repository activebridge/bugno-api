# frozen_string_literal: true

ActiveAdmin.register ProjectUser do
  permit_params :user_id, :project_id, :role
end
