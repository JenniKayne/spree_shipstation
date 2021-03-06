module Spree
  class Shipment < Spree::Base
    module ShipstationExport
      def shipstation_valid?
        inventory_units.any? { |unit| unit.variant.shipstation_valid? }
      end
    end
  end
end
