##
# Service object creates request data for GP Webpay CREATE_ORDER operation.
#
# Examples:
# => Create order which will remember credit card and send back TOKEN.
# > GpWebpay::Http::CreateOrder.call(order_number: 146, amount: 456, currency: 978, deposit_flag: 1, user_param1: 'T')
# => Use returned token to skip adding card again:
# > GpWebpay::Http::CreateOrder.call(order_number: 147, amount: 456, currency: 978, deposit_flag: 1, user_param1: 'S', token: 'TOKEN')

module GpWebpay
  module Http
    class CreateOrder < BaseSignedRequest
      def initialize(attributes, locale, merchant_number: nil, url_attributes: {})
        super(attributes, locale, 'CREATE_ORDER', merchant_number: merchant_number, url_attributes: url_attributes)
      end

      protected

      def callback_url
        GpWebpay::Engine.routes.url_helpers.gp_webpay_orders_path({ merchant_number: config.merchant_number, locale: locale }.merge(url_attributes))
      end
    end
  end
end
