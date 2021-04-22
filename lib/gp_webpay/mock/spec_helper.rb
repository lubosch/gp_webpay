require 'savon/mock/spec_helper'

module GpWebpay
  module SpecHelper
    class Interface
      include Savon::SpecHelper
      include RSpec::Mocks::ExampleMethods

      def params_with_digest(params, merchant_number = :default)
        config = GpWebpay.config[merchant_number] || GpWebpay.config.default
        params.merge(
          'DIGEST' => GpWebpay::OpensslSecurity.generate_digest(config, params.values.join('|'))
        )
      end

      def params_with_both_digests(params, merchant_number = :default)
        config = GpWebpay.config[merchant_number] || GpWebpay.config.default
        params.merge(
          'DIGEST' => GpWebpay::OpensslSecurity.generate_digest(config, params.values.join('|')),
          'DIGEST1' => GpWebpay::OpensslSecurity.generate_digest(config, "#{params.values.join('|')}|#{config.merchant_number}")
        )
      end

      def stub_card_token(token, status: 'VERIFIED', success: true, valid: true)
        allow(GpWebpay::Ws::Services::GetTokenStatus)
          .to receive(:call).with(hash_including(token_data: token, message_id: anything))
                .and_return(instance_double(GpWebpay::Ws::WsResponse, valid?: valid, success?: success, status: status))
      end

      def stub_master_payment_status(payment_number, status: 'OK', success: true, valid: true)
        allow(GpWebpay::Ws::Services::GetMasterPaymentStatus)
          .to receive(:call).with(hash_including(payment_number: payment_number, message_id: anything))
                .and_return(instance_double(GpWebpay::Ws::WsResponse, valid?: valid, success?: success, status: status))
      end

      def stub_payment_status(payment_number, status: 'VERIFIED', sub_status: 'SETTLED', success: true, valid: true)
        allow(GpWebpay::Ws::Services::GetPaymentStatus)
          .to receive(:call).with(hash_including(payment_number: payment_number, message_id: anything))
                .and_return(instance_double(GpWebpay::Ws::WsResponse, valid?: valid, success?: success, status: status,
                                            params: { sub_status: sub_status }))
      end

      def stub_usage_based_payment(attributes, valid: true, success: true, status: '', result_text: 'OK', response_token_data: nil)
        allow(GpWebpay::Ws::Services::ProcessUsageBasedPayment)
          .to receive(:call).with(
            hash_including(
              {
                message_id: anything,
                payment_number: anything,
                order_number: anything,
                currency_code: anything,
                capture_flag: '1'
              }.merge(attributes)
            )
          ).and_return(instance_double(GpWebpay::Ws::WsResponse,
                                       valid?: valid, success?: success, status: status, result_text: result_text,
                                       pr_code: success ? '0' : '123', sr_code: success ? '0' : '4',
                                       params: { token_data: response_token_data || attributes[:token_data] }))
      end

      def stub_token_revoke(token, valid: true, success: true, status: 'REVOKED', result_text: 'OK')
        allow(GpWebpay::Ws::Services::ProcessTokenRevoke)
          .to receive(:call).with(
            hash_including({ message_id: anything }.merge(token_data: token))
          ).and_return(instance_double(GpWebpay::Ws::WsResponse,
                                       valid?: valid, success?: success, status: status, result_text: result_text,
                                       pr_code: success ? '0' : '123', sr_code: success ? '0' : '4'))
      end

      def stub_refund_payment(attributes, valid: true, success: true, status: '', result_text: 'OK')
        allow(GpWebpay::Ws::Services::ProcessRefundPayment)
          .to receive(:call).with(
            hash_including({ message_id: anything }.merge(attributes))
          ).and_return(instance_double(GpWebpay::Ws::WsResponse,
                                       valid?: valid, success?: success, status: status, result_text: result_text,
                                       pr_code: success ? '0' : '123', sr_code: success ? '0' : '4'))
      end

      def stub_capture_reverse(attributes, valid: true, success: true, status: '', result_text: 'OK')
        allow(GpWebpay::Ws::Services::ProcessCaptureReverse)
          .to receive(:call).with(
            hash_including({ message_id: anything }.merge(attributes))
          ).and_return(instance_double(GpWebpay::Ws::WsResponse,
                                       valid?: valid, success?: success, status: status, result_text: result_text,
                                       pr_code: success ? '0' : '123', sr_code: success ? '0' : '4'))
      end

      def stub_cancel_capture(attributes, valid: true, success: true, status: '', result_text: 'OK')
        allow(GpWebpay::Ws::Services::ProcessCancelCapture)
          .to receive(:call).with(
            hash_including({ message_id: anything }.merge(attributes))
          ).and_return(instance_double(GpWebpay::Ws::WsResponse,
                                       valid?: valid, success?: success, status: status, result_text: result_text,
                                       pr_code: success ? '0' : '123', sr_code: success ? '0' : '4'))
      end
    end

    def gp_webpay
      @gp_webpay ||= Interface.new
    end
  end
end
