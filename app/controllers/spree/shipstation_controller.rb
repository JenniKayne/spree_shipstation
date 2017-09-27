include SpreeShipstation

module Spree
  class ShipstationController < BaseController
    include BasicSslAuthentication
    layout false

    protect_from_forgery except: :shipnotify

    def shipnotify
      url = request.body.read
      Spree::ShipmentNotice.new(url)

      render plain: 'OK'
    rescue => error
      message = "Error::ShipstationController.shipnotify #{error.message}"
      ExceptionNotifier.notify_exception(error, data: { msg: message })
      render plain: error.message, status: :bad_request
    end
  end
end
