Rails.application.routes.draw do
  # mount GpWebpay::Engine => "/gp_webpay"
  mount GpWebpay::Engine => GpWebpay.config.mount_at, as: 'gp_webpay'
end
