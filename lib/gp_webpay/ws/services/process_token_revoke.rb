##
# Service object changes credit card token status to "REVOKED".
# Should be used when user decides to remove card from system.
#
# @param [Hash] attributes for GP Webpay
#
# @return [GpwebpayWsResponse] response value object

module GpWebpay
  module Ws
    module Services
      class ProcessTokenRevoke < BaseSignedRequest
        OPERATION_NAME = :process_token_revoke
        REQUEST_NAME = :token_revoke_request
        RESPONSE_NAME = :process_token_revoke_response
        RESPONSE_ENTITY_NAME = :token_revoke_response
      end
    end
  end
end
