require 'rspec'

require 'roda'
require 'rack/test'
require 'pry'

require 'roda/plugins/controller'

module SpecHelpers
  def _app(&block)
    c = Class.new(Roda)
    c.class_eval(&block)

    c
  end

  def app(config = nil, &block)
    return @app unless config || block_given?

    @app ||= _app do
      if config
        plugin :controller, config
      else
        plugin :controller
      end

      route(&block)
    end
  end
end

RSpec.configure do |c|
  c.include Rack::Test::Methods
  c.include SpecHelpers
end
