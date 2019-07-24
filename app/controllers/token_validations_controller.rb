# frozen_string_literal: true

class TokenValidationsController < DeviseTokenAuth::TokenValidationsController
  protected

  def render_validate_token_success
    render json: {
      success: true,
      data: UserSerializer.new(@resource).as_json
    }
  end
end
