module Spree
  class Order < Spree::Base
    module ShipstationExport
      def shipstation_exported!
        update(shipstation_exported_at: Time.zone.now) unless shipstation_exported_at.present?
      end

      def shipstation_valid?
        shipments.any?(&:shipstation_valid?)
      end
    end
  end
end
