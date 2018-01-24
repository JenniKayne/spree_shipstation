include SpreeShipstation

module Spree
  class ShipstationController < BaseController
    # include BasicSslAuthentication
    layout false

    protect_from_forgery except: :shipnotify

    def shipnotify
      debug('shipnotify params', params)
      json = request.body.read
      debug('shipnotify json', json)
      data = JSON.parse(json)
      debug('shipnotify data', data)
      if data['resource_type'] == 'ITEM_SHIP_NOTIFY'
        Spree::ShipmentNotice.new(data['resource_url'])
      end

      render plain: 'OK', status: :ok
    rescue StandardError => error
      message = "Error::ShipstationController.shipnotify #{error.message}"
      Rails.logger.error(message)
      ExceptionNotifier.notify_exception(error, data: { msg: message })
      render plain: error.message, status: :bad_request
    end

    def debug(label, param)
      Rails.logger.debug(label)
      Rails.logger.debug(param.inspect)
    end
  end
end
