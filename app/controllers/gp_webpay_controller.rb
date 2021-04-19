class GpWebpayController < GpWebpay.config.parent_controller.constantize
  skip_before_action :verify_authenticity_token if defined?(verify_authenticity_token)
  prepend_before_action :set_external_order_number
  prepend_before_action :validate_gpwebpay_response
  prepend_before_action :set_gpwebpay_response

  def set_gpwebpay_response
    @gpwebpay_response = GpWebpay::Http::HttpResponse.from_hash(params, params[:merchant_number])
  end

  def validate_gpwebpay_response
    head :forbidden unless @gpwebpay_response.valid?
  end

  def set_external_order_number
    @external_order_number = @gpwebpay_response.params[:order_number]
  end
end
