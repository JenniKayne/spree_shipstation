module Spree
  module BasicSslAuthentication
    extend ActiveSupport::Concern

    included do
      # ssl_required
      before_action :authenticate
    end

    protected

    def authenticate
      # authenticate_or_request_with_http_basic do |username, password|
      #   username == Shipstation.username && password == Shipstation.password
      # end
    end
  end
end
