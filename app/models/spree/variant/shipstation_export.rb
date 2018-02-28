module Spree
  class Variant < Spree::Base
    module ShipstationExport
      def shipstation_valid?
        !product.is_e_gift_card
      end
    end
  end
end
