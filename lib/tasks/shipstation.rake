namespace :spree do
  namespace :shipstation do
    desc 'Export New Orders'
    task export_orders: :environment do
      SpreeShipstation::ExportOrdersJob.perform_later
    end

    desc 'Handle Webhook Shipment Details URL'
    task :webhook_shipment, [:url] do |_t, args|
      Spree::ShipmentNotice.new(args.url)
    end
  end
end
