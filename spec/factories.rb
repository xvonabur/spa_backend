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
end
