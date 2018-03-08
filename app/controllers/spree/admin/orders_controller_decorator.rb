Spree::Admin::OrdersController.class_eval do
  def shipstation_export
    order = Spree::Order.find_by_number(params[:id])

    if Spree::ShipstationManager.new(:export_order, order: order, disable_error_handling: true).success?
      flash[:success] = Spree.t(:shipstation_export_successful)
    else
      flash[:error] = Spree.t(:shipstation_export_error)
    end
  rescue StandardError => error
    flash[:error] = error.message
  ensure
    redirect_back fallback_location: spree.edit_admin_order_url(order)
  end
end
