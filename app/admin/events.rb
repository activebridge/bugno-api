# frozen_string_literal: true

ActiveAdmin.register Event do
  permit_params Event.new.attributes.keys
end
