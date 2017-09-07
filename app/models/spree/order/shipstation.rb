module Spree
  class Order < Spree::Base
    module Shipstation
      def shipstation_order_params
        {}
      end

      def shipstation_exported!
        update(shipstation_exported_at: Time.zone.now) unless shipstation_exported_at.present?
      end
    end
  end
end
