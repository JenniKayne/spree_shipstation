module Spree
  class Order < Spree::Base
    module ShipstationExport
      include ShipstationExportParams

      def shipstation_params
        shipstation_params_base.merge(
          billTo: bill_address.present? ? bill_address.shipstation_params : {},
          shipTo: ship_address.present? ? ship_address.shipstation_params : {},
          items: shipstation_params_items,
          advancedOptions: shipstation_params_advanced_options
        )
      end

      def shipstation_exported!
        update(shipstation_exported_at: Time.zone.now) unless shipstation_exported_at.present?
      end
    end
  end
end
