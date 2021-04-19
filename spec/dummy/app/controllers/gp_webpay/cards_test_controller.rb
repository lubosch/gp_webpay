module GpWebpay
  class CardsTestController < GpWebpay::OrdersController
    def index
      super do |external_order_number, _gpwebpay_response|
        redirect_to "/#{external_order_number}"
      end
    end

    def create
      super do |external_order_number, _gpwebpay_response|
        redirect_to "/#{external_order_number}"
      end
    end
  end
end
