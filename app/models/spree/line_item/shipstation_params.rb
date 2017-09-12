module Spree
  class LineItem < Spree::Base
    module ShipstationParams
      def shipstation_params
        {
          lineItemKey: id,
          sku: variant.sku,
          name: product.name,
          quantity: quantity,
          unitPrice: price.to_s,
          taxAmount: shipstation_tax.to_s,
          shippingAmount: quantity,
          options: variant.shipstation_options,
          productId: product.id,
          fulfillmentSku: variant.sku,
          adjustment: false,
          upc: variant.sku
        }
      end

      def shipstation_tax
        adjustments.tax.sum(:amount)
      end
    end
  end
end
