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
      class ProcessCaptureReverse < BaseSignedRequest
        OPERATION_NAME = :process_capture_reverse
        REQUEST_NAME = :capture_reverse_request
        RESPONSE_NAME = :process_capture_reverse_response
        RESPONSE_ENTITY_NAME = :capture_reverse_response
      end
    end
  end
end
