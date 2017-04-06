# frozen_string_literal: true
require 'responders/serialized_responder'

class AppResponder < ActionController::Responder
  include Responders::SerializedResponder
end
