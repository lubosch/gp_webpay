##
# Service object checks if GP Webpay WS service is available.
#
# 1. Send request :echo operation to SOUP API.
# 2. Receive answer, return true if response is present in desired format.
# 3. Return false if
#    - response is not in valid format.
#    - request fails client-side.
#    - request returns failure from server.
#
# @return [Boolean]  GP Webpay is available

module GpWebpay
  module Ws
    class Echo < Service
      attr_reader :config

      def initialize
        super
        @config = GpWebpay.config.default
      end

      def call
        res = client.call(:echo)
        res.body && res.body[:echo_response].present?
      rescue Savon::HTTPError, Savon::SOAPFault
        false
      end

      def client
        @client ||= Savon.client(wsdl: config.wsdl_file, endpoint: config.ws_url, pretty_print_xml: true)
      end
    end
  end
end
