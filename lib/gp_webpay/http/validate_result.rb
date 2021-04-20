##
# Service object validates result received from GP Webpay response redirect.
#
# 1. Use public cert of GP Webpay to verify it comes from GP Webpay.
# 2. Whitelist allowed attributes which are expected from GP Webpay.
# 3. Calculate digest and make sure it corresponds to received DIGEST.
# 3. Calculate digest1 and make sure it corresponds to received DIGEST1
#    (which includes our merchant number for extra security).
#
# @param [Hash] Parameters hash received in response from GP Webpay.
#
# @return [Boolean] true if signature is valid for both digests.

module GpWebpay
  module Http
    class ValidateResult < Service
      attr_reader :params, :config

      def initialize(params, config)
        super()
        @params = params
        @config = config
      end

      def call
        params['DIGEST'] && params['DIGEST1'] && OpensslSecurity.validate_digests(
          config,
          params['DIGEST'] => digest_verification,
          params['DIGEST1'] => digest1_verification
        )
      end

      private

      DIGEST_ALLOWED_ATTRIBUTES = %w[
        OPERATION
        ORDERNUMBER
        MERORDERNUM
        MD
        PRCODE
        SRCODE
        RESULTTEXT
        USERPARAM1
        ADDINFO
        TOKEN
        EXPIRY
        ACSRES
        ACCODE
        PANPATTERN
        DAYTOCAPTURE
        TOKENREGSTATUS
      ].freeze

      def digest_verification
        @digest_verification ||= (DIGEST_ALLOWED_ATTRIBUTES & params.keys).map { |key| params[key] }.join('|')
      end

      def digest1_verification
        "#{digest_verification}|#{config.merchant_number}"
      end
    end
  end
end
