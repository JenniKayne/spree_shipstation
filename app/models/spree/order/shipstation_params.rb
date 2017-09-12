module Spree
  class Order < Spree::Base
    module ShipstationParams
      def shipstation_params
        shipstation_params_base.merge(
          billTo: bill_address.present? ? bill_address.shipstation_params : {},
          shipTo: ship_address.present? ? ship_address.shipstation_params : {},
          items: shipstation_params_items,
          advancedOptions: shipstation_params_advanced_options
        )
      end

      private

      def shipstation_params_base
        # shipByDate: "2015-07-05T00:00:00.0000000",
        # customerNotes: "Thanks for ordering!",
        # internalNotes: "Customer called and would like to upgrade shipping",
        # gift: true,
        # giftMessage: "Thank you!",
        # packageCode: "package",
        # confirmation: "delivery",
        # shipDate: "2015-07-02",
        {
          orderNumber: number,
          orderKey: id,
          orderDate: completed_at,
          orderStatus: "awaiting_shipment"
        }.
          merge!(shipstation_params_totals).
          merge!(shipstation_params_payment).
          merge!(shipstation_params_customer).
          merge!(shipstation_params_shipment).
          merge!(shipstation_params_weight)
      end

      def shipstation_params_customer
        {
          customerId: user ? user.id : nil,
          customerUsername: user ? user.email : nil,
          customerEmail: email,
        }
      end

      def shipstation_params_items
        line_items.map &:shipstation_params
      end

      def shipstation_params_payment
        payment = payments.completed.first
        return {} if payment.blank?
        {
          paymentDate: payment.created_at,
          paymentMethod: payment.payment_method.name,
        }
      end

      def shipstation_params_shipment
        shipment = shipments.first
        shipment ? shipment.shipstation_params : {}
      end

      def shipstation_params_totals
        {
          amountPaid: total.to_s,
          taxAmount: tax_total.to_s,
          shippingAmount: ship_total.to_s,
        }
      end

      def shipstation_params_weight
        {
          weight: {
            value: shipments.map(&:shipstation_params_weight).sum,
            units: SpreeShipstation.configuration.weight_unit
          }
        }
      end

      def shipstation_params_advanced_options
        {
          # warehouseId: SpreeShipstation.configuration.warehouse_id,
          # nonMachinable: false,
          # saturdayDelivery: false,
          # containsAlcohol: false,
          # mergedOrSplit: false,
          # mergedIds: [],
          # parentId: nil,
          # storeId: SpreeShipstation.configuration.store_id,
          # customField1: "Custom data that you can add to an order. See Custom Field #2 & #3 for more info!",
          # customField2: "Per UI settings, this information can appear on some carrier's shipping labels. See link",
          # customField3: "https://help.shipstation.com/hc/en-us/articles/206639957",
          # source: "Webstore",
          # billToParty: nil,
          # billToAccount: nil,
          # billToPostalCode: nil,
          # billToCountryCode: nil
        }
      end
    end
  end
end
