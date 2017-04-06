# frozen_string_literal: true
class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(request)
    @default || request.headers
                       .fetch(:accept)
                       .include?("version=#{@version}")
  end
end
