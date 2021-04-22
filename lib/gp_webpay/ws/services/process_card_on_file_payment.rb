##
# Service object creates fast payment without need of leaving user from Wilio web / app.
# It uses VERIFIED credit card token to skip filling card again and 3D secure step.
#
# @param [Hash] attributes for GP Webpay
#
# @return [GpWebpay::Ws::WsResponse] response value object

module GpWebpay
  module Ws
    module Services
      class ProcessCardOnFilePayment < BaseSignedRequest
        OPERATION_NAME = :process_card_on_file_payment
        REQUEST_NAME = :card_on_file_payment_request
        RESPONSE_NAME = :process_card_on_file_payment_response
        RESPONSE_ENTITY_NAME = :card_on_file_payment_response
        SERVICE_EXCEPTION = :card_on_file_payment_service_exception

        def initialize(attributes, merchant_number: :default)
          config = GpWebpay.config[merchant_number] || GpWebpay.config.default
          merged_attributes = {
            return_url: GpWebpay::Engine.routes.url_helpers.gp_webpay_orders_url({ merchant_number: config.merchant_number })
          }.merge(attributes)
          super(merged_attributes, merchant_number: merchant_number)
        end

        def rescue_from_soap(exception)
          response = WsResponse.from_fault_error(exception.to_hash, self.class::SERVICE_EXCEPTION, config.merchant_number)

          if response.valid? && response.params[:authentication_link].present?
            raise GpWebpayConfirmationRequired.new('GP Webpay requires authentication', response.params[:authentication_link])
          else
            response
          end
        end

        class GpWebpayConfirmationRequired < GpWebpay::Error
          attr_reader :authentication_link

          def initialize(msg = nil, authentication_link = nil)
            super(msg)
            @authentication_link = authentication_link
          end
        end
      end
    end
  end
end
