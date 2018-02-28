module Spree
  class Shipment < Spree::Base
    module ShipstationParams
      def shipstation_params
        return shipstation_params_empty if shipping_method.blank?
        {
          carrierCode: shipping_method.code,
          serviceCode: shipping_method.code,
          requestedShippingService: shipping_method.name
        }
      end

      def shipstation_params_empty
        {
          carrierCode: nil,
          serviceCode: nil,
          requestedShippingService: nil
        }
      end

      def shipstation_params_weight
        inventory_units.
          select { |unit| unit.variant.shipstation_valid? }.
          map { |unit| unit.variant.weight.to_f * unit.quantity }.
          sum
      end
    end
  end
end
