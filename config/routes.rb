GpWebpay::Engine.routes.draw do
  resources GpWebpay.config.orders_controller.delete_suffix('Controller').underscore, only: %i[create index], as: :gp_webpay_orders
  resources GpWebpay.config.cards_controller.delete_suffix('Controller').underscore, only: %i[create index], as: :gp_webpay_cards
end
