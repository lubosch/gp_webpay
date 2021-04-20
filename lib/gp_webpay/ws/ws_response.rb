module GpWebpay
  module Ws
    class WsResponse < Response
      attr_accessor :validation_response

      def self.from_success(hash, response_name, response_entity_name, merchant_number)
        validation_response = hash.dig(response_name, response_entity_name)
        new(
          original_response: hash,
          params: validation_response,
          status: validation_response[:status],
          token: validation_response[:token_data],
          pr_code: validation_response[:primary_return_code],
          sr_code: validation_response[:secondary_return_code],
          merchant_number: merchant_number,
          result_text: 'OK'
        )
      end

      def self.from_fault_error(hash, exception, merchant_number)
        validation_response = hash.dig(:fault, :detail, exception)
        new(
          original_response: hash,
          params: validation_response,
          status: :error,
          pr_code: validation_response[:primary_return_code],
          sr_code: validation_response[:secondary_return_code],
          result_text: hash.dig(:fault, :faultstring),
          merchant_number: merchant_number
        )
      end

      def self.from_http_error(hash, merchant_number)
        new(
          original_response: hash,
          params: {},
          status: :error,
          pr_code: nil,
          sr_code: nil,
          result_text: "Internal HTTP request error: '#{hash[:code]}'",
          merchant_number: merchant_number
        )
      end

      def valid?
        @valid ||= GpWebpay::Ws::ValidateResult.call(params, config)
      end

      def success?
        @success ||= (status != :error)
      end
    end
  end
end
