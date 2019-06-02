# frozen_string_literal: true

ActiveAdmin.register ProjectUser do
  permit_params ProjectUser.new.attributes.keys
end
