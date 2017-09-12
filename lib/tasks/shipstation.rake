namespace :spree do
  namespace :shipstation do
    desc 'Export New Orders'
    task export_orders: :environment do
      Spree::ShipstationManager.new(:export_orders, true)
    end
  end
end
