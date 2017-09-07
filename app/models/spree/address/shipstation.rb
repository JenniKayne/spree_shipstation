module Spree
  class Address < Spree::Base
    module Shipstation
      def shipstation_params_name
        [firstname, lastname].reject(&:blank?).join(' ')
      end

      def shipstation_params
        {
          name: shipstation_params_name,
          company: company,
          street1: address1,
          street2: address2,
          city: city,
          state: state_name,
          postalCode: zipcode,
          country: country.present? ? country.iso : '',
          phone: phone,
          residential: true
        }
      end
    end
  end
end
