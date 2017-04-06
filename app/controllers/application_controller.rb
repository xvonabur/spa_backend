# frozen_string_literal: true
require 'app_responders'
class ApplicationController < ActionController::API
  include Knock::Authenticable
end
