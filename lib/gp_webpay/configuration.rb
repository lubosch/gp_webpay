module GpWebpay
  class Configuration
    attr_accessor :configurations, :parent_controller, :mount_at, :orders_controller, :cards_controller

    def initialize
      @configurations = {}
      @parent_controller = 'AbstractController::Base'
      @mount_at = '/gp_webpay'
      @orders_controller = 'OrdersController'
      @cards_controller = 'CardsController'
    end

    def default
      @configurations[:default]
    end

    def [](config_name)
      return if config_name.blank?

      @configurations[config_name] || find_configuration_by_merchant_number(config_name)
    end

    def find_configuration_by_merchant_number(merchant_number)

      config = @configurations.find { |_key, value| puts _key;value.merchant_number.to_s == merchant_number.to_s }
      return nil if config.blank?

      config[-1]
    end

    def add_configuration(merchant_number:, default: false)
      @configurations[merchant_number] = MerchantConfig.new(merchant_number)
      yield(@configurations[merchant_number])
      @configurations[:default] = @configurations[merchant_number] if default || !@configurations[:default]
    end

    def remove_configuration(merchant_number:)
      @configurations.delete(merchant_number)
      @configurations[:default] = @configurations[@configurations.keys[0]]
    end

    class MerchantConfig
      attr_accessor :merchant_number, :merchant_pem, :merchant_password, :gpe_pem, :wsdl_file, :provider, :enabled_methods, :production
      attr_writer :http_url, :ws_url

      DEFAULT_HTTP_URL = 'https://3dsecure.gpwebpay.com/pgw/order.do'.freeze
      DEFAULT_HTTP_TEST_URL = 'https://test.3dsecure.gpwebpay.com/pgw/order.do'.freeze
      DEFAULT_WS_URL = 'https://3dsecure.gpwebpay.com/pay-ws/v1/PaymentService'.freeze
      DEFAULT_WS_TEST_URL = 'https://test.3dsecure.gpwebpay.com/pay-ws/v1/PaymentService'.freeze

      def initialize(merchant_number)
        @merchant_number = merchant_number
        @production = false
        @wsdl_file = File.read("#{GpWebpay.root}/config/wsdl/cws_v1.wsdl")
        @enabled_methods = 'credit_card,transfer'
      end

      def http_url
        if @http_url.nil?
          production ? DEFAULT_HTTP_URL : DEFAULT_HTTP_TEST_URL
        else
          @http_url
        end
      end

      def ws_url
        if @ws_url.nil?
          production ? DEFAULT_WS_URL : DEFAULT_WS_TEST_URL
        else
          @ws_url
        end
      end
    end
  end
end
