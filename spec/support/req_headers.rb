# frozen_string_literal: true
def auth_header_for_user(user_id)
  token = Knock::AuthToken.new(payload: { sub: user_id }).token

  {
    'Authorization' => "Bearer #{token}"
  }
end

def api_header(version = 1)
  {
    'Accept' => "application/vnd.api+json; version=#{version.to_i}"
  }
end

def api_auth_headers(user_id, version)
  auth_header_for_user(user_id.to_i).merge!(api_header(version))
end
