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
      class ProcessTokenPayment < BaseSignedRequest
        OPERATION_NAME = :process_token_payment
        REQUEST_NAME = :token_payment_request
        RESPONSE_NAME = :process_token_payment_response
        RESPONSE_ENTITY_NAME = :token_payment_response
        SERVICE_EXCEPTION = :payment_service_exception

        def initialize(attributes, merchant_number: :default)
          super(attributes.except(:return_url), merchant_number: merchant_number)
        end
      end
    end
  end
end
