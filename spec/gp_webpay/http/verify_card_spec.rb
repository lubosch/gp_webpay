require 'spec_helper'

RSpec.describe GpWebpay::Http::VerifyCard do
  subject { described_class.call(params, 'en', url_attributes: { country: 'SK' }) }

  context 'all attrs are present' do
    let(:params) do
      {
        order_number: 1,
        add_info: true
      }
    end

    it 'returns url and attributes with digest' do
      expect(subject.url).to eq 'https://test.3dsecure.gpwebpay.com/pgw/order.do'
      expect(subject.params)
        .to eq('ADDINFO' => '<?xml version="1.0" encoding="UTF-8"?><additionalInfoRequest xmlns="http://gpe.cz/gpwebpay/additionalInfo/request" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="4.0"><requestReturnInfo><requestCardsDetails>true</requestCardsDetails></requestReturnInfo></additionalInfoRequest>',
               'MERCHANTNUMBER' => '11111111',
               'OPERATION' => 'CARD_VERIFICATION',
               'ORDERNUMBER' => 1,
               'URL' => '/gp_webpay/cards_test?country=SK&locale=en&merchant_number=11111111',
               'LANG' => 'en',
               'DIGEST' => 'dZkw6NvZ4/j/JS4Hfl1BKCLBNKhX4ZoADeHFHR93djBRf7uI2kJSP4z+Q1JQnux3MMIUKYk/5djr6vdv/l7YqQ==')
    end
  end
end
