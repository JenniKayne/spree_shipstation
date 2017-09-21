class SpreeShipstation::ExportOrdersJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    Spree::ShipstationManager.new(:export_orders, true)
  end
end
