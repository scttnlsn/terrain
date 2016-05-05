require 'active_support'

require 'terrain/config'
require 'terrain/errors'
require 'terrain/resource'

module Terrain
  extend self

  def config
    @config ||= Config.new
  end

  def configure
    yield config
  end
end
