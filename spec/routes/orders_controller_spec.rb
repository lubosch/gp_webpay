require 'rails_helper'

RSpec.describe GpWebpay::OrdersTestController, type: :controller do
  describe '#index' do
    it 'routes to custom test controller' do
      expect(get: gp_webpay_orders_path).to route_to(controller: 'gp_webpay/orders_test', action: 'index')
    end
  end

  describe '#create' do
    it 'routes to custom test controller' do
      expect(post: gp_webpay_orders_path).to route_to(controller: 'gp_webpay/orders_test', action: 'create')
    end
  end
end
