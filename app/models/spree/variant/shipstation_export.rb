module Spree
  class Variant < Spree::Base
    module ShipstationExport
      def shipstation_valid?
        true
      end
    end
  end
end
