namespace :spree do
  namespace :shipstation do
    desc 'Export New Orders'
    task export_orders: :environment do
      SpreeShipstation::ExportOrdersJob.perform_later
    end
  end
end
