# frozen_string_literal: true
def auth_header_for_user(user_id)
  token = Knock::AuthToken.new(payload: { sub: user_id }).token

  {
    'Authorization' => "Bearer #{token}"
  }
end
