module Spree
  class Order < Spree::Base
    module ShipstationExportParams
      def shipstation_params_base
        {
          orderNumber: number,
          orderKey: id,
          orderDate: completed_at.to_s,
          paymentDate: "2015-06-29T08:46:27.0000000",
          shipByDate: "2015-07-05T00:00:00.0000000",
          orderStatus: "awaiting_shipment",
          customerId: 37701499,
          customerUsername: "headhoncho@whitehouse.gov",
          customerEmail: "headhoncho@whitehouse.gov",
          amountPaid: 218.73,
          taxAmount: tax_total,
          shippingAmount: 10,
          customerNotes: "Thanks for ordering!",
          internalNotes: "Customer called and would like to upgrade shipping",
          gift: true,
          giftMessage: "Thank you!",
          paymentMethod: "Credit Card",
          requestedShippingService: "Priority Mail",
          arrierCode: "fedex",
          serviceCode: "fedex_2day",
          packageCode: "package",
          confirmation: "delivery",
          shipDate: "2015-07-02",
          weight: {
            value: 25,
            units: "ounces"
          },
          dimensions: {
            units: "inches",
            length: 7,
            width: 5,
            height: 6
          },
          insuranceOptions: {
            provider: "carrier",
            insureShipment: true,
            insuredValue: 200
          },
          internationalOptions: {
            contents: nil,
            customsItems: nil
          }
        }
      end

      def shipstation_params_items
        line_items.map &:shipstation_params
      end

      def shipstation_params_advanced_options
        {}
        # {
        #   warehouseId: SpreeShipstation.configuration.warehouse_id,
        #   nonMachinable: false,
        #   saturdayDelivery: false,
        #   containsAlcohol: false,
        #   mergedOrSplit: false,
        #   mergedIds: [],
        #   parentId: nil,
        #   storeId: SpreeShipstation.configuration.store_id,
        #   customField1: "Custom data that you can add to an order. See Custom Field #2 & #3 for more info!",
        #   customField2: "Per UI settings, this information can appear on some carrier's shipping labels. See link",
        #   customField3: "https://help.shipstation.com/hc/en-us/articles/206639957",
        #   source: "Webstore",
        #   billToParty: nil,
        #   billToAccount: nil,
        #   billToPostalCode: nil,
        #   billToCountryCode: nil
        # }
      end
    end
  end
end
