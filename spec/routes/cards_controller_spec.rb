require 'rails_helper'

RSpec.describe GpWebpay::CardsTestController, type: :controller do
  describe '#index' do
    it 'routes to custom test controller' do
      expect(get: gp_webpay_cards_path).to route_to(controller: 'gp_webpay/cards_test', action: 'index')
    end
  end

  describe '#create' do
    it 'routes to custom test controller' do
      expect(post: gp_webpay_cards_path).to route_to(controller: 'gp_webpay/cards_test', action: 'create')
    end
  end
end
