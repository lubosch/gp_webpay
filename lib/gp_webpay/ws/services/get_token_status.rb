##
# Service object returns current status of credit card token.
# Should be used to keep credit card status up-to date,
# should be called before process_token_payment to ensure card is still VERIFIED.
#
# @param [Hash] attributes for GP Webpay
#
# @return [GpWebpay::Ws::WsResponse] response value object

module GpWebpay
  module Ws
    module Services
      class GetTokenStatus < BaseSignedRequest
        OPERATION_NAME = :get_token_status
        REQUEST_NAME = :token_status_request
        RESPONSE_NAME = :get_token_status_response
        RESPONSE_ENTITY_NAME = :token_status_response
      end
    end
  end
end
