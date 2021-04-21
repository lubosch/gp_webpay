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
      class ProcessMasterPaymentRevoke < BaseSignedRequest
        OPERATION_NAME = :process_master_payment_revoke
        REQUEST_NAME = :master_payment_revoke_request
        RESPONSE_NAME = :process_master_payment_revoke_response
        RESPONSE_ENTITY_NAME = :master_payment_status_response
      end
    end
  end
end
