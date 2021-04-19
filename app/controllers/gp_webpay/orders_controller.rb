module GpWebpay
  class OrdersController < GpWebpayController
    def index
      yield(@external_order_number, @gpwebpay_response)
    end

    def create
      yield(@external_order_number, @gpwebpay_response)
    end
  end
end
