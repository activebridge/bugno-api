# frozen_string_literal: true

ActiveAdmin.register User do
  permit_params User.new.attributes.keys
end
