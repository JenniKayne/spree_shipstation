include SpreeShipstation

module Spree
  class ShipstationController < BaseController
    # include BasicSslAuthentication
    layout false

    protect_from_forgery except: :shipnotify

    def shipnotify
      json = request.body.read
      data = JSON.parse(json)
      if data['resource_type'] == 'ITEM_SHIP_NOTIFY'
        Spree::ShipmentNotice.new(data['resource_url'])
      end

      render plain: 'OK'
    rescue => error
      message = "Error::ShipstationController.shipnotify #{error.message}"
      ExceptionNotifier.notify_exception(error, data: { msg: message })
      render plain: error.message, status: :bad_request
    end
  end
end
