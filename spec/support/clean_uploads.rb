# frozen_string_literal: true
RSpec.configure do |config|
  config.after(:each) do
    FileUtils.rm_rf(File.join(Rails.root.to_s, 'public', 'uploads', 'test'))
  end
end
