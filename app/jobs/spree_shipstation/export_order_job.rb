class SpreeShipstation::ExportOrderJob < ApplicationJob
  queue_as :shipstation

  def perform(order)
    Spree::ShipstationManager.new(:export_order, order: order)
  end
end
