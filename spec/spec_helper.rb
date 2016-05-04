ENV['RAILS_ENV'] = 'test'

require 'terrain'

require 'rails'
require 'action_controller/railtie'
require 'active_model_serializers'
require 'active_model_serializers/railtie'
require 'active_record'
require 'airborne'
require 'factory_girl'
require 'faker'
require 'rspec/rails'

LOGGER = Logger.new('/dev/null')

Rails.logger = LOGGER
ActiveModelSerializers.logger = LOGGER
ActiveRecord::Base.logger = LOGGER

DATABASE = {
  adapter: 'sqlite3',
  database: ':memory:'
}

ActiveRecord::Migration.verbose = false
ActiveRecord::Base.establish_connection(DATABASE)

module Terrain
  class Application < ::Rails::Application
    def self.find_root(from)
      Dir.pwd
    end

    config.eager_load = false
    config.secret_key_base = 'secret'
  end
end

Terrain::Application.initialize!

module Helpers
  def serialize(value, options = {})
    ActiveModelSerializers::SerializableResource.new(value, options).as_json.symbolize_keys
  end

  def policy_double(methods)
    Class.new(Struct.new(:user, :record)) do
      methods.each do |name, value|
        define_method(name) { value }
      end
    end
  end
end

RSpec.configure do |config|
  config.include Helpers
  config.include FactoryGirl::Syntax::Methods

  config.use_transactional_fixtures = true
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
