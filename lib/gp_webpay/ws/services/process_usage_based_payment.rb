##
# Service object creates fast payment without need of leaving user from Wilio web / app.
# It uses VERIFIED credit card token to skip filling card again and 3D secure step.
#
# @param [Hash] attributes for GP Webpay
#
# @return [GpwebpayWsResponse] response value object

module GpWebpay
  module Ws
    module Services
      class ProcessUsageBasedPayment < BaseSignedRequest
        OPERATION_NAME = :process_usage_based_payment
        REQUEST_NAME = :usage_based_payment_request
        RESPONSE_NAME = :process_usage_based_payment_response
        RESPONSE_ENTITY_NAME = :usage_based_payment_response
        SERVICE_EXCEPTION = :payment_service_exception
      end
    end
  end
end
