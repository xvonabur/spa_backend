# frozen_string_literal: true
module Responders
  module SerializedResponder
    def initialize(controller, resources, options = {})
      puts "Called initializzzzz"
      super
      serializer = (
        controller.class.name.gsub('Controller', '').singularize + 'Serializer'
      ).constantize
      if resource.kind_of?(ActiveRecord::Relation)
        options.merge!(arrayserializer: serializer)
      else
        options.merge!(serializer: serializer)
      end
    end
  end
end
