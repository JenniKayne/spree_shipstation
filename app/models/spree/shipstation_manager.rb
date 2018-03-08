class Spree::ShipstationManager
  ALLOWED_ACTIONS = %i[export_orders export_order].freeze

  def initialize(action, params = {})
    @success = false
    @verbose = params[:verbose] == true
    return unless ALLOWED_ACTIONS.include?(action)
    send(action, params)
  end

  def success?
    @success
  end

  private

  def export_order(params = {})
    order = params[:order]
    puts "Spree::ShipstationManager export order #{order.number}" if @verbose
    if order.shipstation_valid?
      response = Shipstation::Order.create order.shipstation_params
      export_order_validate_response(order, response)
      order.shipstation_exported!
      puts '> Exported' if @verbose
      @success = true
    elsif @verbose
      puts '> Order not suitable for shipstation'
    end
  rescue StandardError => e
    if params[:disable_error_handling]
      raise e
    else
      message = prepare_error_message("Error::Shipstation.export_order #{e.message}", order)
      ExceptionNotifier.notify_exception(e, data: { msg: message })
    end
  end

  def export_order_validate_response(order, response)
    raise prepare_error_message(response, order) if response.class != Hash
    raise prepare_error_message(response['Message'], order) if response['Message'].present?
  end

  def export_orders(_params = {})
    if @verbose
      puts "Spree::ShipstationManager export_orders #{collect_export_orders.size}"
    end
    collect_export_orders.each do |order|
      begin
        export_order(order: order)
      rescue StandardError => e
        message = prepare_error_message("Error::Shipstation.export_orders #{e.message}", order)
        ExceptionNotifier.notify_exception(e, data: { msg: message })
        next
      end
    end
    @success = true
  end

  def prepare_error_message(message, order)
    "Shipstation Export Error: #{message}\n\nOrder: #{order.shipstation_params}"
  end

  def collect_export_orders
    puts 'Spree::ShipstationManager collect_export_orders' if @verbose
    Spree::Order.complete.where(shipstation_exported_at: nil)
  end
end
