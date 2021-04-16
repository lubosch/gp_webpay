##
# Service object creates request data for GP Webpay CARD_VERIFICATION operation.

module GpWebpay
  module Http
    class VerifyCard < BaseSignedRequest
      def initialize(attributes, locale, merchant_number: nil)
        super(attributes, locale, 'CARD_VERIFICATION', merchant_number: merchant_number)
      end

      protected

      def callback_url
        # TODO: later
        # 'Rails.application.routes.url_helpers.gpwebpay_verify_cards_url(additional_url_params)'
        'card_verification_callback'
      end
    end
  end
end
