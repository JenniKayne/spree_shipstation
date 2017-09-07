class CreateSpreeShipstations < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_orders, :shipstation_exported_at, :datetime, default: nil    
  end
end
