module Spree
  class LineItem < Spree::Base
    module Shipstation
      def shipstation_params
        {
          lineItemKey: id,
          sku: variant.sku,
          name: product.name,
          quantity: quantity,
          unitPrice: price,
          taxAmount: shipstation_tax,
          shippingAmount: quantity,
          options: variant.shipstation_options,
          productId: product.slug,
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
