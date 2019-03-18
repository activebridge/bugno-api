# frozen_string_literal: true

require 'rails_helper'

describe API::V4::Base, type: :request do
  it_behaves_like 'api_version', 4
end
