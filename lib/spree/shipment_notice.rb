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
    rescue StandardError => error
      handle_error(error, :initialize, details_url)
    end

    private

    def apply_response(response)
      json = JSON.parse(response.body)
      json['shipments'].each do |shipment|
        apply(shipment['orderNumber'], shipment['trackingNumber'])
      end
    rescue StandardError => error
      handle_error(error, :apply_response, response)
    end

    def apply(order_id, tracking_number)
      order = Spree::Order.find_by_number(order_id)
      raise("Order not found #{order_id}") if order.blank?

      update(order, tracking_number)
    rescue StandardError => error
      handle_error(error, :apply, order: order_id, tracking: tracking_number)
    end

    def capture_payments(order)
      return false unless order.update_with_updater!
      order = Spree::Order.find_by_number(order.number)
      order.payments.valid.where.not(state: :completed).each do |payment|
        begin
          source = payment.source_type.to_s.demodulize
          if source == 'BraintreeCheckout' && payment.payment_source.can_settle?(nil)
            payment.send('settle!')
          else
            payment.send('capture!')
          end
        rescue StandardError => error
          handle_error(error, :settle_payments, order: order.number)
          next
        end
      end
      order.update_with_updater!
    end

    def handle_error(error, action_name, content = {})
      notification_params = { data: { msg: "ShipmentNotice.#{action_name} #{error.message}", content: content } }
      ExceptionNotifier.notify_exception(error, notification_params)
      Rails.logger.error(error.message)
      Rails.logger.error(notification_params.inspect)
      false
    end

    def ship_shipments(order, tracking_number)
      order = Spree::Order.find_by_number(order.number)
      order.shipments.ready.each do |shipment|
        begin
          shipment.reload
          next if shipment.shipped?
          shipment.ready! if shipment.can_ready?
          shipment.update_attribute(:tracking, tracking_number)
          shipment.ship!
        rescue StandardError => error
          handle_error(error, :update, order: order.number, tracking: tracking_number, shipment: shipment.number)
          next
        end
      end
      order.update_with_updater!
    end

    def update(order, tracking_number)
      ship_shipments(order, tracking_number) if capture_payments(order)
    end
  end
end
