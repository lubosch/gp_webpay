module GpWebpay
  module Http
    class HttpResponse < Response
      GP_TO_ATTRS_MAPPER =
        {
          'OPERATION' => :operation,
          'ORDERNUMBER' => :order_number,
          'MERORDERNUM' => :mer_order_num,
          'MD' => :md,
          'PRCODE' => :pr_code,
          'SRCODE' => :sr_code,
          'RESULTTEXT' => :result_text,
          'USERPARAM1' => :user_param1,
          'TOKEN' => :token,
          'EXPIRY' => :expiry,
          'ACSRES' => :acsres,
          'ACCODE' => :accode,
          'PANPATTERN' => :pan_pattern,
          'DAYTOCAPTURE' => :day_to_capture,
          'TOKENREGSTATUS' => :token_reg_status
        }.freeze

      def self.from_hash(hash, merchant_number)
        params = GP_TO_ATTRS_MAPPER.each_with_object({}) do |(k, v), result|
          value = hash[k.to_s] || hash[k.to_sym]
          result[v] = value if value
        end

        params[:add_info] = Hash.from_xml(hash['ADDINFO']) if hash['ADDINFO']

        new(original_response: hash, result_text: params[:result_text], token: params[:token], status: nil,
            pr_code: params[:pr_code], sr_code: params[:sr_code], params: params, merchant_number: merchant_number)
      end

      def valid?
        GpWebpay::Http::ValidateResult.call(original_response, config)
      end
    end
  end
end
