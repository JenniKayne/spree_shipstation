module Spree
  class LineItem < Spree::Base
    module ShipstationExport
      def shipstation_valid?
        variant.shipstation_valid?
      end
    end
  end
end
