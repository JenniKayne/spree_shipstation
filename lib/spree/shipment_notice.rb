module Spree
  class ShipmentNotice
    attr_reader :error

    def initialize(details_url)
      require 'httparty'

      auth = {
        username: Shipstation.username,
        password: Shipstation.password
      }
      response = HTTParty.get(details_url, basic_auth: auth)
      apply_response(response)
    rescue => error
      handle_error(error, :initialize, details_url)
    end

    private

    def apply_response(response)
      json = JSON.parse(response.body)
      json['shipments'].each do |shipment|
        apply(shipment['orderNumber'], shipment['trackingNumber'])
      end
    rescue => error
      handle_error(error, :apply_response, response)
    end

    def apply(order_id, tracking_number)
      order = Spree::Order.find_by_number(order_id)
      raise("Order not found #{order_id}") if order.blank?

      update(order, tracking_number)
    rescue => error
      handle_error(error, :apply, order: order.number, tracking: tracking_number)
    end

    def update(order, tracking_number)
      order.shipments.each do |shipment|
        begin
          shipment.update_attribute(:tracking, tracking_number)

          unless shipment.shipped?
            shipment.ship!
            # shipment.reload.update_attribute(:state, 'shipped')
            # shipment.inventory_units.each &:ship!
            # shipment.touch :shipped_at
          end
        rescue => error
          handle_error(error, :update, order: order.number, tracking: tracking_number, shipment: shipment.number)
          next
        end
      end
    end

    def handle_error(error, action_name, content = {})
      notification_params = { data: { msg: "ShipmentNotice.#{action_name} #{error.message}", content: content } }
      ExceptionNotifier.notify_exception(error, notification_params)
      Rails.logger.error(error)
      false
    end
  end
end
