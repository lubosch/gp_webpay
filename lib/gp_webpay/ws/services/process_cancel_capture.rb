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
      class ProcessCancelCapture < BaseSignedRequest
        OPERATION_NAME = :process_authorization_reverse
        REQUEST_NAME = :authorization_reverse_request
        RESPONSE_NAME = :process_authorization_reverse_response
        RESPONSE_ENTITY_NAME = :authorization_reverse_response
      end
    end
  end
end
