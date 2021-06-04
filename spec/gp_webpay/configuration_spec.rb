require 'rails_helper'

RSpec.describe GpWebpay::Configuration do
  it 'sets default configuration from spec helper file' do
    expect(GpWebpay.config.default)
      .to have_attributes(merchant_number: '11111111',
                          merchant_pem: "-----BEGIN ENCRYPTED PRIVATE KEY-----\nMIIBrzBJBgkqhkiG9w0BBQ0wPDAbBgkqhkiG9w0BBQwwDgQIFzu3x2lsP5UCAggA\nMB0GCWCGSAFlAwQBKgQQcr3l9PxPLd/ZGWUMHVgBSgSCAWCsVa5fdj5fzU0zEB88\nV+50zU9pf5WluY0ztNlPFHLduDb5XDVTyrwI+YrpPTeU7gqbrqw8lKaizqTmBqCA\n/Czizr32cFXgcvsKoVxiQPS8uaiNeDSTlTOVXPOPCtN4cPzrVDrqvA3vHmJ+QqDZ\ncuoutmAi1Ys3mFB3Xdy6qnZD1q6MW0f0YNxz0RxY9FU7qgffZCvMCBmaThmhdD9R\n1EP0/Cx6O6bSSOoVPblzk+epTxQFvOcD3CR1iHxtz2SRTiuFbvfzPTQQ1IpQIx6a\nL09CvvzTuXGfvLCR6dBu0tbMQyPjD+dbSbmwoKo1BdnDc44ihwYktcnODRvehcSU\nlCECuIU51PD3IKkfixAjAUzaVO//uDCTU/fEzXzAOwMka529XxIz4WNVwZUrU1nS\nGMIp7zGlAACYB39j4ZSwJm0om1sMr4poHcA2Er6kN5iQ3m+f6AjsIh+H4cFvr+R1\npVp9\n-----END ENCRYPTED PRIVATE KEY-----",
                          merchant_password: 'Password',
                          gpe_pem: "-----BEGIN CERTIFICATE-----\nMIIBDTCBuAIJAMcza0CFealrMA0GCSqGSIb3DQEBBQUAMA0xCzAJBgNVBAYTAlNL\nMCAXDTIxMDQxNjExNTIwMVoYDzIxMjEwMzIzMTE1MjAxWjANMQswCQYDVQQGEwJT\nSzBcMA0GCSqGSIb3DQEBAQUAA0sAMEgCQQDAop2mxPL4D7+eICOUelcxe9TEpYeL\nbi/gwNds2rTe3P0BM/e2z9uxreN2JfwFVmB0SF6dMOTIRPCOIvVTOilzAgMBAAEw\nDQYJKoZIhvcNAQEFBQADQQBXy5sBXXy7zxVkWHebMX7U9VXzV00yFIGjl3gvHrAq\nFTOzd6+XiwLqPiBeXTSkzTkDj9ed+h6ka73uh3i7zkay\n-----END CERTIFICATE-----",
                          provider: '3040',
                          http_url: 'https://test.3dsecure.gpwebpay.com/pgw/order.do',
                          ws_url: 'https://test.3dsecure.gpwebpay.com/pay-ws/v1/PaymentService')
  end

  describe '#add_configuration' do
    before do
      GpWebpay.configure do |config|
        config.add_configuration(merchant_number: '2222222', default: true) do |merchant_config|
          merchant_config.merchant_number = '2222222'
          merchant_config.merchant_pem = "-----BEGIN ENCRYPTED PRIVATE KEY-----\nMIIBrzBJBgkqhkiG9w0BBQ0wPDAbBgkqhkiG9w0BBQwwDgQIFzu3x2lsP5UCAggA\nMB0GCWCGSAFlAwQBKgQQcr3l9PxPLd/ZGWUMHVgBSgSCAWCsVa5fdj5fzU0zEB88\nV+50zU9pf5WluY0ztNlPFHLduDb5XDVTyrwI+YrpPTeU7gqbrqw8lKaizqTmBqCA\n/Czizr32cFXgcvsKoVxiQPS8uaiNeDSTlTOVXPOPCtN4cPzrVDrqvA3vHmJ+QqDZ\ncuoutmAi1Ys3mFB3Xdy6qnZD1q6MW0f0YNxz0RxY9FU7qgffZCvMCBmaThmhdD9R\n1EP0/Cx6O6bSSOoVPblzk+epTxQFvOcD3CR1iHxtz2SRTiuFbvfzPTQQ1IpQIx6a\nL09CvvzTuXGfvLCR6dBu0tbMQyPjD+dbSbmwoKo1BdnDc44ihwYktcnODRvehcSU\nlCECuIU51PD3IKkfixAjAUzaVO//uDCTU/fEzXzAOwMka529XxIz4WNVwZUrU1nS\nGMIp7zGlAACYB39j4ZSwJm0om1sMr4poHcA2Er6kN5iQ3m+f6AjsIh+H4cFvr+R1\npVp9\n-----END ENCRYPTED PRIVATE KEY-----"
          merchant_config.merchant_password = 'Superpass'
          merchant_config.gpe_pem = "-----BEGIN CERTIFICATE-----\nMIIBDTCBuAIJAMcza0CFealrMA0GCSqGSIb3DQEBBQUAMA0xCzAJBgNVBAYTAlNL\nMCAXDTIxMDQxNjExNTIwMVoYDzIxMjEwMzIzMTE1MjAxWjANMQswCQYDVQQGEwJT\nSzBcMA0GCSqGSIb3DQEBAQUAA0sAMEgCQQDAop2mxPL4D7+eICOUelcxe9TEpYeL\nbi/gwNds2rTe3P0BM/e2z9uxreN2JfwFVmB0SF6dMOTIRPCOIvVTOilzAgMBAAEw\nDQYJKoZIhvcNAQEFBQADQQBXy5sBXXy7zxVkWHebMX7U9VXzV00yFIGjl3gvHrAq\nFTOzd6+XiwLqPiBeXTSkzTkDj9ed+h6ka73uh3i7zkay\n-----END CERTIFICATE-----"
          merchant_config.provider = '3002'
          merchant_config.production = true
        end
      end
    end

    after do
      GpWebpay.configure do |config|
        config.remove_configuration(merchant_number: '2222222')
      end
    end
    it 'sets another configuration as default' do
      expect(GpWebpay.config.default)
        .to have_attributes(merchant_number: '2222222',
                            merchant_pem: "-----BEGIN ENCRYPTED PRIVATE KEY-----\nMIIBrzBJBgkqhkiG9w0BBQ0wPDAbBgkqhkiG9w0BBQwwDgQIFzu3x2lsP5UCAggA\nMB0GCWCGSAFlAwQBKgQQcr3l9PxPLd/ZGWUMHVgBSgSCAWCsVa5fdj5fzU0zEB88\nV+50zU9pf5WluY0ztNlPFHLduDb5XDVTyrwI+YrpPTeU7gqbrqw8lKaizqTmBqCA\n/Czizr32cFXgcvsKoVxiQPS8uaiNeDSTlTOVXPOPCtN4cPzrVDrqvA3vHmJ+QqDZ\ncuoutmAi1Ys3mFB3Xdy6qnZD1q6MW0f0YNxz0RxY9FU7qgffZCvMCBmaThmhdD9R\n1EP0/Cx6O6bSSOoVPblzk+epTxQFvOcD3CR1iHxtz2SRTiuFbvfzPTQQ1IpQIx6a\nL09CvvzTuXGfvLCR6dBu0tbMQyPjD+dbSbmwoKo1BdnDc44ihwYktcnODRvehcSU\nlCECuIU51PD3IKkfixAjAUzaVO//uDCTU/fEzXzAOwMka529XxIz4WNVwZUrU1nS\nGMIp7zGlAACYB39j4ZSwJm0om1sMr4poHcA2Er6kN5iQ3m+f6AjsIh+H4cFvr+R1\npVp9\n-----END ENCRYPTED PRIVATE KEY-----",
                            merchant_password: 'Superpass',
                            gpe_pem: "-----BEGIN CERTIFICATE-----\nMIIBDTCBuAIJAMcza0CFealrMA0GCSqGSIb3DQEBBQUAMA0xCzAJBgNVBAYTAlNL\nMCAXDTIxMDQxNjExNTIwMVoYDzIxMjEwMzIzMTE1MjAxWjANMQswCQYDVQQGEwJT\nSzBcMA0GCSqGSIb3DQEBAQUAA0sAMEgCQQDAop2mxPL4D7+eICOUelcxe9TEpYeL\nbi/gwNds2rTe3P0BM/e2z9uxreN2JfwFVmB0SF6dMOTIRPCOIvVTOilzAgMBAAEw\nDQYJKoZIhvcNAQEFBQADQQBXy5sBXXy7zxVkWHebMX7U9VXzV00yFIGjl3gvHrAq\nFTOzd6+XiwLqPiBeXTSkzTkDj9ed+h6ka73uh3i7zkay\n-----END CERTIFICATE-----",
                            provider: '3002',
                            http_url: 'https://3dsecure.gpwebpay.com/pgw/order.do',
                            ws_url: 'https://3dsecure.gpwebpay.com/pay-ws/v1/PaymentService')
    end

    it 'keeps old default configuration intact' do
      expect(GpWebpay.config['11111111'])
        .to have_attributes(merchant_number: '11111111',
                            merchant_pem: "-----BEGIN ENCRYPTED PRIVATE KEY-----\nMIIBrzBJBgkqhkiG9w0BBQ0wPDAbBgkqhkiG9w0BBQwwDgQIFzu3x2lsP5UCAggA\nMB0GCWCGSAFlAwQBKgQQcr3l9PxPLd/ZGWUMHVgBSgSCAWCsVa5fdj5fzU0zEB88\nV+50zU9pf5WluY0ztNlPFHLduDb5XDVTyrwI+YrpPTeU7gqbrqw8lKaizqTmBqCA\n/Czizr32cFXgcvsKoVxiQPS8uaiNeDSTlTOVXPOPCtN4cPzrVDrqvA3vHmJ+QqDZ\ncuoutmAi1Ys3mFB3Xdy6qnZD1q6MW0f0YNxz0RxY9FU7qgffZCvMCBmaThmhdD9R\n1EP0/Cx6O6bSSOoVPblzk+epTxQFvOcD3CR1iHxtz2SRTiuFbvfzPTQQ1IpQIx6a\nL09CvvzTuXGfvLCR6dBu0tbMQyPjD+dbSbmwoKo1BdnDc44ihwYktcnODRvehcSU\nlCECuIU51PD3IKkfixAjAUzaVO//uDCTU/fEzXzAOwMka529XxIz4WNVwZUrU1nS\nGMIp7zGlAACYB39j4ZSwJm0om1sMr4poHcA2Er6kN5iQ3m+f6AjsIh+H4cFvr+R1\npVp9\n-----END ENCRYPTED PRIVATE KEY-----",
                            merchant_password: 'Password',
                            gpe_pem: "-----BEGIN CERTIFICATE-----\nMIIBDTCBuAIJAMcza0CFealrMA0GCSqGSIb3DQEBBQUAMA0xCzAJBgNVBAYTAlNL\nMCAXDTIxMDQxNjExNTIwMVoYDzIxMjEwMzIzMTE1MjAxWjANMQswCQYDVQQGEwJT\nSzBcMA0GCSqGSIb3DQEBAQUAA0sAMEgCQQDAop2mxPL4D7+eICOUelcxe9TEpYeL\nbi/gwNds2rTe3P0BM/e2z9uxreN2JfwFVmB0SF6dMOTIRPCOIvVTOilzAgMBAAEw\nDQYJKoZIhvcNAQEFBQADQQBXy5sBXXy7zxVkWHebMX7U9VXzV00yFIGjl3gvHrAq\nFTOzd6+XiwLqPiBeXTSkzTkDj9ed+h6ka73uh3i7zkay\n-----END CERTIFICATE-----",
                            provider: '3040',
                            http_url: 'https://test.3dsecure.gpwebpay.com/pgw/order.do',
                            ws_url: 'https://test.3dsecure.gpwebpay.com/pay-ws/v1/PaymentService')
    end
  end

  describe '#[]' do
    before do
      GpWebpay.configure do |config|
        config.add_configuration(merchant_number: 'another', default: false) do |merchant_config|
          merchant_config.merchant_number = '2222222'
          merchant_config.merchant_pem = "-----BEGIN ENCRYPTED PRIVATE KEY-----\nMIIBrzBJBgkqhkiG9w0BBQ0wPDAbBgkqhkiG9w0BBQwwDgQIFzu3x2lsP5UCAggA\nMB0GCWCGSAFlAwQBKgQQcr3l9PxPLd/ZGWUMHVgBSgSCAWCsVa5fdj5fzU0zEB88\nV+50zU9pf5WluY0ztNlPFHLduDb5XDVTyrwI+YrpPTeU7gqbrqw8lKaizqTmBqCA\n/Czizr32cFXgcvsKoVxiQPS8uaiNeDSTlTOVXPOPCtN4cPzrVDrqvA3vHmJ+QqDZ\ncuoutmAi1Ys3mFB3Xdy6qnZD1q6MW0f0YNxz0RxY9FU7qgffZCvMCBmaThmhdD9R\n1EP0/Cx6O6bSSOoVPblzk+epTxQFvOcD3CR1iHxtz2SRTiuFbvfzPTQQ1IpQIx6a\nL09CvvzTuXGfvLCR6dBu0tbMQyPjD+dbSbmwoKo1BdnDc44ihwYktcnODRvehcSU\nlCECuIU51PD3IKkfixAjAUzaVO//uDCTU/fEzXzAOwMka529XxIz4WNVwZUrU1nS\nGMIp7zGlAACYB39j4ZSwJm0om1sMr4poHcA2Er6kN5iQ3m+f6AjsIh+H4cFvr+R1\npVp9\n-----END ENCRYPTED PRIVATE KEY-----"
          merchant_config.merchant_password = 'Superpass'
          merchant_config.gpe_pem = "-----BEGIN CERTIFICATE-----\nMIIBDTCBuAIJAMcza0CFealrMA0GCSqGSIb3DQEBBQUAMA0xCzAJBgNVBAYTAlNL\nMCAXDTIxMDQxNjExNTIwMVoYDzIxMjEwMzIzMTE1MjAxWjANMQswCQYDVQQGEwJT\nSzBcMA0GCSqGSIb3DQEBAQUAA0sAMEgCQQDAop2mxPL4D7+eICOUelcxe9TEpYeL\nbi/gwNds2rTe3P0BM/e2z9uxreN2JfwFVmB0SF6dMOTIRPCOIvVTOilzAgMBAAEw\nDQYJKoZIhvcNAQEFBQADQQBXy5sBXXy7zxVkWHebMX7U9VXzV00yFIGjl3gvHrAq\nFTOzd6+XiwLqPiBeXTSkzTkDj9ed+h6ka73uh3i7zkay\n-----END CERTIFICATE-----"
          merchant_config.provider = '3002'
          merchant_config.production = true
        end
      end
    end

    after do
      GpWebpay.configure do |config|
        config.remove_configuration(merchant_number: 'another')
      end
    end

    it 'returns config by config name' do
      expect(GpWebpay.config['another']).to be_present
    end

    context 'when name not matched' do
      it 'finds by merchant number' do
        expect(GpWebpay.config['2222222']).to be_present
      end
    end
  end
end
