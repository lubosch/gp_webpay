module GpWebpay
  class Response
    attr_accessor :original_response,
                  :result_text,
                  :token,
                  :status,
                  :pr_code,
                  :sr_code,
                  :config,
                  :params

    # rubocop:disable Metrics/ParameterLists
    def initialize(original_response:, result_text:, status:, pr_code:, sr_code:, params:, token: nil, merchant_number: nil)
      @original_response = original_response
      @result_text = result_text
      @token = token
      @status = status
      @pr_code = pr_code
      @sr_code = sr_code
      @params = params
      @merchant_number = merchant_number
      @config = GpWebpay.config[merchant_number] || GpWebpay.config.default
    end

    # rubocop:enable Metrics/ParameterLists

    def valid?
    end

    def success?
      pr_code == '0' && sr_code == '0'
    end
  end
end
