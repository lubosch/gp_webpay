require 'rails_helper'

RSpec.describe GpWebpay::Http::Services::VerifyCard do
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
               'URL' => 'http://localhost:3000/gp_webpay/cards_test?country=SK&locale=en&merchant_number=11111111',
               'LANG' => 'en',
               'DIGEST' => 'R7hrDnavz1/8pda2iNzxgCnWNsP6bvTt2NCEDFt1ER2Ag/eYLVMEAyz5x9rDkA+zpalLWNy9otwWwNzcC1jzFg==')
    end
  end
end
