GpWebpay.configure do |config|
  config.mount_at = '/gp_webpay'
  config.parent_controller = 'ActionController::Base'
  config.orders_controller = 'OrdersTestController'
  config.cards_controller = 'CardsTestController'
  config.add_configuration(merchant_number: '11111111') do |merchant_config|
    merchant_config.merchant_number = '11111111'
    merchant_config.merchant_pem = "-----BEGIN ENCRYPTED PRIVATE KEY-----\nMIIBrzBJBgkqhkiG9w0BBQ0wPDAbBgkqhkiG9w0BBQwwDgQIFzu3x2lsP5UCAggA\nMB0GCWCGSAFlAwQBKgQQcr3l9PxPLd/ZGWUMHVgBSgSCAWCsVa5fdj5fzU0zEB88\nV+50zU9pf5WluY0ztNlPFHLduDb5XDVTyrwI+YrpPTeU7gqbrqw8lKaizqTmBqCA\n/Czizr32cFXgcvsKoVxiQPS8uaiNeDSTlTOVXPOPCtN4cPzrVDrqvA3vHmJ+QqDZ\ncuoutmAi1Ys3mFB3Xdy6qnZD1q6MW0f0YNxz0RxY9FU7qgffZCvMCBmaThmhdD9R\n1EP0/Cx6O6bSSOoVPblzk+epTxQFvOcD3CR1iHxtz2SRTiuFbvfzPTQQ1IpQIx6a\nL09CvvzTuXGfvLCR6dBu0tbMQyPjD+dbSbmwoKo1BdnDc44ihwYktcnODRvehcSU\nlCECuIU51PD3IKkfixAjAUzaVO//uDCTU/fEzXzAOwMka529XxIz4WNVwZUrU1nS\nGMIp7zGlAACYB39j4ZSwJm0om1sMr4poHcA2Er6kN5iQ3m+f6AjsIh+H4cFvr+R1\npVp9\n-----END ENCRYPTED PRIVATE KEY-----"
    merchant_config.merchant_password = 'Password'
    merchant_config.gpe_pem = "-----BEGIN CERTIFICATE-----\nMIIBDTCBuAIJAMcza0CFealrMA0GCSqGSIb3DQEBBQUAMA0xCzAJBgNVBAYTAlNL\nMCAXDTIxMDQxNjExNTIwMVoYDzIxMjEwMzIzMTE1MjAxWjANMQswCQYDVQQGEwJT\nSzBcMA0GCSqGSIb3DQEBAQUAA0sAMEgCQQDAop2mxPL4D7+eICOUelcxe9TEpYeL\nbi/gwNds2rTe3P0BM/e2z9uxreN2JfwFVmB0SF6dMOTIRPCOIvVTOilzAgMBAAEw\nDQYJKoZIhvcNAQEFBQADQQBXy5sBXXy7zxVkWHebMX7U9VXzV00yFIGjl3gvHrAq\nFTOzd6+XiwLqPiBeXTSkzTkDj9ed+h6ka73uh3i7zkay\n-----END CERTIFICATE-----"
    merchant_config.provider = '3040'
  end
end
GpWebpay::Engine.routes.default_url_options = { host: 'localhost', port: 3000, protocol: 'http' }
