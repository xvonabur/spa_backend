# frozen_string_literal: true
module Requests
  module JsonHelpers
    def json
      JSON.parse(response.body)
    end

    def json_api_date(date)
      date.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
    end
  end
end
