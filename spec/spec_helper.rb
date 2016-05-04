ENV['RAILS_ENV'] = 'test'

require 'terrain'

require 'rails'
require 'action_controller/railtie'
require 'active_record'
require 'airborne'
require 'rspec/rails'

LOGGER = Logger.new('/dev/null')

Rails.logger = LOGGER
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
