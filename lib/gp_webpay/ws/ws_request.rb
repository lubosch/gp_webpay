module GpWebpay
  module Ws
    class WsRequest
      attr_accessor :attributes

      ATTRS_TO_GP_MAPPER = {
        'ins0:messageId' => :message_id,
        'ins0:provider' => :provider,
        'ins0:merchantNumber' => :merchant_number,
        'ins0:paymentNumber' => :payment_number,
        'ins0:masterPaymentNumber' => :master_payment_number,
        'ins0:orderNumber' => :order_number,
        'ins0:captureNumber' => :capture_number,
        'ins0:amount' => :amount,
        'ins0:currencyCode' => :currency_code,
        'ins0:captureFlag' => :capture_flag,
        'ins0:tokenData' => :token_data,
        'ins0:returnUrl' => :return_url
      }.freeze

      def initialize(attributes)
        @attributes = attributes || {}
      end

      def to_gpwebpay
        @to_gpwebpay ||= transform_to_gpwebpay
      end

      private

      def transform_to_gpwebpay
        ATTRS_TO_GP_MAPPER.each_with_object({}) do |(k, v), attrs|
          attribute_value = attributes[v] || attributes[v.to_s]
          attrs[k] = attribute_value if attribute_value
        end
      end
    end
  end
end
