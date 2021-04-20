##
# Service object returns current status of payment.
#
# @param [Hash] attributes for GP Webpay
#
# @return [GpwebpayWsResponse] response value object

module GpWebpay
  module Ws
    module Services
      class GetPaymentStatus < BaseSignedRequest
        OPERATION_NAME = :get_payment_status
        REQUEST_NAME = :payment_status_request
        RESPONSE_NAME = :get_payment_status_response
        RESPONSE_ENTITY_NAME = :payment_status_response
      end
    end
  end
end
