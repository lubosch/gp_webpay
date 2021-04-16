##
# Service object signs request which can be send to GP Webpay payment gateway.
#
# 1. Use request value object to translate attributes to correct GP Webpay format and order.
# 2. Append generated digest to attributes.
# 3. prepare url to send for GP Webpay
#
# @param [Hash] optional attributes for GP Webpay
#
# @return [Hash] data needed to make request:
#                 full url for GET request or
#                 url_root and list of attributes for POST request.

module GpWebpay
  module Http
    class BaseSignedRequest < Service
      attr_reader :attributes, :locale, :operation

      def initialize(attributes, locale, operation, merchant_number: :default)
        super()
        @attributes = attributes
        @locale = locale
        @merchant_number = merchant_number
        @operation = operation
        @config = GpWebpay.config[@merchant_number] || GpWebpay.config.default
      end

      def call
        request = HttpRequest.new(
          attributes.merge(
            merchant_number: @config.merchant_number,
            operation: operation,
            url: callback_url
          )
        ).to_gpwebpay

        attrs_with_digest = payment_attributes_with_digest(request)
        uri = URI(@config.http_url)

        ExternalUrl.new(
          url: uri.to_s,
          full_url: build_full_url(uri, attrs_with_digest),
          params: attrs_with_digest
        )
      end

      def callback_url
        raise NotImplementedError
      end

      private

      def build_full_url(uri, attrs)
        uri.query = URI.encode_www_form(attrs)
        uri.to_s
      end

      def digest_text(attrs)
        attrs.values.join('|')
      end

      def payment_attributes_with_digest(attrs)
        digest = OpensslSecurity.generate_digest(@config, digest_text(attrs))
        attrs.merge(
          'DIGEST' => digest,
          'LANG' => locale
        )
      end
    end
  end
end
