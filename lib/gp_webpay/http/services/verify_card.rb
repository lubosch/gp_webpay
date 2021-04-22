##
# Service object creates request data for GP Webpay CARD_VERIFICATION operation.

module GpWebpay
  module Http
    module Services
      class VerifyCard < BaseSignedRequest
        def initialize(attributes, locale, merchant_number: nil, url_attributes: {})
          super(attributes, locale, 'CARD_VERIFICATION', merchant_number: merchant_number, url_attributes: url_attributes)
        end

        protected

        def callback_url
          GpWebpay::Engine.routes.url_helpers.gp_webpay_cards_url({ merchant_number: config.merchant_number, locale: locale }.merge(url_attributes))
        end
      end
    end
  end
end
