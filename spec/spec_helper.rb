require 'rack/test'
require_relative '../topological_sort.rb'

module Helpers
  include Rack::Test::Methods

  def app
    RestfulObjects::Server
  end
end

RSpec.configure do |config|
  config.include Helpers
end

