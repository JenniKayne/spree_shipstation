module SpreeShipstation
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_shipstation'

    config.eager_load_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
      decorate
    end

    def self.decorate
      Spree::Address.class_eval do
        include Spree::Address::ShipstationParams
      end

      Spree::LineItem.class_eval do
        include Spree::LineItem::ShipstationParams
        include Spree::LineItem::ShipstationExport
      end

      Spree::Order.class_eval do
        include Spree::Order::ShipstationParams
        include Spree::Order::ShipstationExport

        state_machine do
          after_transition to: :complete, do: :schedule_shipstation_export
        end

        def schedule_shipstation_export
          SpreeShipstation::ExportOrderJob.perform_later(self)
        end
      end

      Spree::Shipment.class_eval do
        include Spree::Shipment::ShipstationParams
        include Spree::Shipment::ShipstationExport
      end

      Spree::Variant.class_eval do
        include Spree::Variant::ShipstationParams
        include Spree::Variant::ShipstationExport
      end
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
