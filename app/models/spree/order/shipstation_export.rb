module Spree
  class Order < Spree::Base
    module ShipstationExport
      def shipstation_exported!
        update(shipstation_exported_at: Time.zone.now) unless shipstation_exported_at.present?
      end

      def shipstation_valid?
        valid_payments = payments.select { |payment| %w[completed pending processing].include?(payment.state) }
        shipments.any?(&:shipstation_valid?) &&
          total.zero? || (valid_payments.any? && valid_payments.sum(&:amount) == total)
      end
    end
  end
end
