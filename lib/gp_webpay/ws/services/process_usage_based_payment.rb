##
# Service object creates fast payment without need of leaving user from Wilio web / app.
# It uses VERIFIED credit card token to skip filling card again and 3D secure step.
#
# @param [Hash] attributes for GP Webpay
#
# @return [GpWebpay::Ws::WsResponse] response value object

module GpWebpay
  module Ws
    module Services
      class ProcessUsageBasedPayment < BaseSignedRequest
        OPERATION_NAME = :process_usage_based_payment
        REQUEST_NAME = :usage_based_payment_request
        RESPONSE_NAME = :process_usage_based_payment_response
        RESPONSE_ENTITY_NAME = :usage_based_payment_response
        SERVICE_EXCEPTION = :payment_service_exception

        def initialize(attributes, merchant_number: :default)
          config = GpWebpay.config[merchant_number] || GpWebpay.config.default
          merged_attributes = {
            return_url: GpWebpay::Engine.routes.url_helpers.gp_webpay_orders_url({ merchant_number: config.merchant_number })
          }.merge(attributes)
          super(merged_attributes, merchant_number: merchant_number)
        end
      end
    end
  end
end
