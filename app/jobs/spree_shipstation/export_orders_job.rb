class SpreeShipstation::ExportOrdersJob < ApplicationJob
  queue_as :shipstation

  def perform(*_args)
    Spree::ShipstationManager.new(:export_orders)
  end
end
