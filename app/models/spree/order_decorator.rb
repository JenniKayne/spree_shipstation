Spree::Order.class_eval do
  include Spree::Order::ShipstationExport
end
