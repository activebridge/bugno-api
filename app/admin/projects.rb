# frozen_string_literal: true

ActiveAdmin.register Project do
  permit_params Project.new.attributes.keys
end
