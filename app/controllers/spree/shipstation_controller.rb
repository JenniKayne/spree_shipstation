include SpreeShipstation

module Spree
  class ShipstationController < BaseController
    include BasicSslAuthentication
    layout false

    protect_from_forgery except: :shipnotify

    def shipnotify
      notice = Spree::ShipmentNotice.new(params, request.body.read)

      if notice.apply
        render plain: 'success'
      else
        render plain: notice.error, status: :bad_request
      end
    end
  end
end
