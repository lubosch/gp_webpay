##
# Service object validates result received from GP Webpay response by WS in XML format.
#
# 1. Use public cert of GP Webpay to verify it comes from GP Webpay.
# 2. Whitelist allowed attributes which are expected from GP Webpay.
# 3. Calculate signature and make sure it corresponds to received signature.
#
# @param [Hash] Parameters hash received in XML response from GP Webpay.
#
# @return [Boolean] true if signature is valid for both digests.

module GpWebpay
  module Ws
    class ValidateResult < Service
      attr_reader :params, :config

      DIGEST_ALLOWED_ATTRIBUTES = %i[
        primary_return_code
        secondary_return_code
        message_id
        state
        status
        sub_status
        auth_code
        token_data
        authentication_link
      ].freeze

      def initialize(params, config)
        super()
        @params = params
        @config = config
      end

      def call
        params.present? &&
          params[:signature].present? &&
          OpensslSecurity.validate_digests(config, params[:signature] => digest_verification)
      end

      private

      def digest_verification
        @digest_verification ||= params.slice(*(params.keys & DIGEST_ALLOWED_ATTRIBUTES)).values.join('|')
      end
    end
  end
end
