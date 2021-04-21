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
      class ProcessRefundPayment < BaseSignedRequest
        OPERATION_NAME = :process_refund
        REQUEST_NAME = :refund_request
        RESPONSE_NAME = :process_refund_response
        RESPONSE_ENTITY_NAME = :refund_request_response
      end
    end
  end
end
