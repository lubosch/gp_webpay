##
# Service object returns current status of credit card token.
# Should be used to keep credit card status up-to date,
# should be called before process_token_payment to ensure card is still VERIFIED.
#
# @param [Hash] attributes for GP Webpay
#
# @return [GpwebpayWsResponse] response value object

module GpWebpay
  module Ws
    module Services
      class GetMasterPaymentStatus < BaseSignedRequest
        OPERATION_NAME = :get_master_payment_status
        REQUEST_NAME = :master_payment_status_request
        RESPONSE_NAME = :get_master_payment_status_response
        RESPONSE_ENTITY_NAME = :master_payment_status_response

        SHORTCUT_TRANSFORMATION = {
          CR: 'CREATED',
          PS: 'ISSUED',
          OK: 'VERIFIED',
          CM: 'REVOKED',
          CI: 'DECLINED',
          CC: 'DECLINED',
          EC: 'EXPIRED',
          EP: 'EXPIRED'
        }.freeze
      end
    end
  end
end
