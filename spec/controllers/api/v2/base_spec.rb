# frozen_string_literal: true

require 'rails_helper'

describe API::V2::Base, type: :request do
  it_behaves_like 'api_version', 2
end
