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
        # packageCode: "package",
        # confirmation: "delivery",
        # shipDate: "2015-07-02",
        {
          orderNumber: number,
          orderKey: number,
          orderDate: completed_at,
          orderStatus: "awaiting_shipment"
        }.
          merge!(shipstation_params_customer).
          merge!(shipstation_params_gift).
          merge!(shipstation_params_notes).
          merge!(shipstation_params_payment).
          merge!(shipstation_params_shipment).
          merge!(shipstation_params_totals).
          merge!(shipstation_params_weight)
      end

      def shipstation_params_customer
        {
          customerId: user ? user.id : nil,
          customerUsername: user ? user.email : nil,
          customerEmail: email,
        }
      end

      def shipstation_params_gift
        {
          gift: false,
          giftMessage: nil,
        }
      end

      def shipstation_params_items
        line_items.map &:shipstation_params
      end

      def shipstation_params_notes
        {
          customerNotes: nil,
          internalNotes: nil,
        }
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
          warehouseId: SpreeShipstation.configuration.warehouse_id,
          storeId: SpreeShipstation.configuration.store_id,
          containsAlcohol: false,
          source: "Webstore",
          customField1: shipstation_params_advanced_custom_field_1,
          customField2: shipstation_params_advanced_custom_field_2,
          customField3: shipstation_params_advanced_custom_field_3,
          nonMachinable: false,
          mergedOrSplit: false,
          mergedIds: [],
          parentId: nil,
          saturdayDelivery: false
        }.
          merge!(shipstation_params_advanced_bill_to)
      end

      def shipstation_params_advanced_bill_to
        {
          billToParty: nil,
          billToAccount: nil,
          billToPostalCode: nil,
          billToCountryCode: nil
        }
      end

      def shipstation_params_advanced_custom_field_1
        nil
      end

      def shipstation_params_advanced_custom_field_2
        nil
      end

      def shipstation_params_advanced_custom_field_3
        nil
      end
    end
  end
end
