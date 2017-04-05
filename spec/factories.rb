# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    email 'user@mail.com'
    password 'pass_123'
  end

  factory :post do
    sequence(:title) { |n| "Title #{n}" }
    sequence(:body) { |n| "Body #{n}" }
    user
  end

  factory :post_with_image, parent: :post do
    image { Rack::Test::UploadedFile.new(fixture_image_path) }
  end

  factory :post_with_jpeg_image, parent: :post do
    image { Rack::Test::UploadedFile.new(fixture_image_path('jpeg')) }
  end
end

def fixture_image_path(ext = 'png')
  File.join(Rails.root, 'spec', 'fixtures', 'images', "bat-logo.#{ext}")
end
