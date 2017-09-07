namespace :spree do
  namespace :shipstation do
    desc 'Export New Orders'
    task export_orders: :environment do
      puts 'Order export START@' + Time.zone.now.to_s
      Spree::Shipstation.export_orders
    end
  end
end
