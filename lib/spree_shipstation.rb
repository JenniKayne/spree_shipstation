require 'spree_core'
require 'spree_shipstation/engine'
require 'spree_shipstation/version'
require 'shipstation'

module SpreeShipstation
  class Configuration
    attr_accessor :api_key
    attr_accessor :api_secret
    attr_accessor :store_id
    attr_accessor :warehouse_id

    def initialize
      @api_key = ''
      @api_secret = ''
      @store_id = ''
      @warehouse_id = ''
    end
  end

  class << self
    attr_accessor :configuration
    def configure
      self.configuration ||= Configuration.new
      yield(configuration)

      Shipstation.username  = configuration.api_key
      Shipstation.password  = configuration.api_secret
    end
  end
end
