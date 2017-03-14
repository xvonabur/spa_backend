# frozen_string_literal: true
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'localhost:3000', '0.0.0.0:3000', 'localhost:4000', '*.buddywins.org',
            'spa-front.s3-website.eu-central-1.amazonaws.com',
            'd21s0coozib73c.cloudfront.net'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
