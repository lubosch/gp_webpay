##
# Service object signs request which can be send to GP Webpay payment gateway.
#
# 1. Use request value object to translate attributes to correct GP Webpay format and order.
# 2. Append generated signature to attributes. We expect that XML types are prefixed with 'ins0:' by default.
# 3. send XML WS SOAP API request.
# 4. generate response object:
#    - success containing response.
#    - http error when client-side request fails.
#    - fail error when external server returns fault.
#
# @param [Hash] attributes for GP Webpay
#
# @return [GpwebpayWsResponse] response value object

module GpWebpay
  module Ws
    class BaseSignedRequest < Service
      attr_reader :attributes, :config

      OPERATION_NAME = 'override_me'.freeze
      REQUEST_NAME = 'override_me'.freeze
      RESPONSE_NAME = 'override_me'.freeze
      RESPONSE_ENTITY_NAME = 'override_me'.freeze
      SERVICE_EXCEPTION = :service_exception

      def initialize(attributes, merchant_number: :default)
        @attributes = attributes
        @merchant_number = merchant_number
        @config = GpWebpay.config[@merchant_number] || GpWebpay.config.default
        super()
      end

      def call
        attrs = WsRequest.new(attributes.merge(provider: config.provider, merchant_number: config.merchant_number)).to_gpwebpay

        res = client.call(self.class::OPERATION_NAME, message: { self.class::REQUEST_NAME => attributes_with_signature(attrs) })
        WsResponse.from_success(res.body, self.class::RESPONSE_NAME, self.class::RESPONSE_ENTITY_NAME, config.merchant_number)
      rescue Savon::HTTPError => e
        rescue_from_http(e)
      rescue Savon::SOAPFault => e
        rescue_from_soap(e)
      end

      protected

      def digest_text(attrs)
        attrs.values.join('|')
      end

      def attributes_with_signature(attrs)
        digest = OpensslSecurity.generate_digest(config, digest_text(attrs))
        attrs.merge('ins0:signature' => digest)
      end

      def client
        @client ||= Savon.client(wsdl: config.wsdl_file, endpoint: config.ws_url, pretty_print_xml: true)
      end

      def rescue_from_http(error)
        WsResponse.from_http_error(error.to_hash, config.merchant_number)
      end

      def rescue_from_soap(error)
        WsResponse.from_fault_error(error.to_hash, self.class::SERVICE_EXCEPTION, config.merchant_number)
      end
    end
  end
end
