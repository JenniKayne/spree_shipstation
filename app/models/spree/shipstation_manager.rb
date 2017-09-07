class Spree::ShipstationManager
  def self.export_orders
    orders = Spree::Order.where(shipstation_exported_at: nil)
    orders.each do |order|
      begin
        export_order order
      rescue => error
        MassNotifier::Notification.new('Error::Shipstation.export_orders', error.message)
        next
      end
    end
  end

  def self.export_order(order)
    Shipstation::Order.create order.shipstation_params
    order.shipstation_exported!
  end
end
