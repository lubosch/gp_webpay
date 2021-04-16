module GpWebpay
  module Http
    class HttpRequest
      attr_accessor :attributes

      ATTRS_TO_GP_MAPPER = {
        'MERCHANTNUMBER' => :merchant_number,
        'OPERATION' => :operation,
        'ORDERNUMBER' => :order_number,
        'AMOUNT' => :amount,
        'CURRENCY' => :currency,
        'DEPOSITFLAG' => :deposit_flag,
        'MERORDERNUM' => :mer_order_num,
        'URL' => :url,
        'DESCRIPTION' => :description,
        'MD' => :md,
        'USERPARAM1' => :user_param1,
        'FASTPAYID' => :fast_pay_id,
        'PAYMETHOD' => :paymethod,
        'DISABLEPAYMETHOD' => :disable_paymethod,
        'PAYMETHODS' => :paymethods,
        'EMAIL' => :email,
        'REFERENCENUMBER' => :reference_number,
        'ADDINFO' => :add_info_to_xml,
        'FASTTOKEN' => :fast_token
      }.freeze

      def initialize(attributes)
        @attributes = attributes || {}
      end

      def to_gpwebpay
        @to_gpwebpay ||= transform_to_gpwebpay
      end

      private

      def transform_to_gpwebpay
        result = ATTRS_TO_GP_MAPPER.each_with_object({}) do |(k, v), attrs|
          attribute_value = attributes[v] || attributes[v.to_s]
          attrs[k] = attribute_value if attribute_value
        end
        result = result.merge({ 'ADDINFO' => add_info_to_xml }) if attributes[:add_info] || attributes['add_info']
        result
      end

      def add_info_to_xml
        builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
          xml.additionalInfoRequest(xmlns: 'http://gpe.cz/gpwebpay/additionalInfo/request',
                                    'xmlns:xsi': 'http://www.w3.org/2001/XMLSchema-instance',
                                    version: 4.0) do
            xml.requestReturnInfo do
              xml.requestCardsDetails true
            end
          end
        end
        builder.to_xml(
          save_with: Nokogiri::XML::Node::SaveOptions::AS_XML
        ).strip.gsub("\n", '')
      end
    end
  end
end
