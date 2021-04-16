require 'spec_helper'

RSpec.describe GpWebpay::Http::VerifyCard do
  subject { described_class.call(params, 'en') }

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
               'URL' => 'card_verification_callback',
               'LANG' => 'en',
               'DIGEST' => 'R831i+6N7qzN2p7tjEY28xUq88MQ+Ysw6CUC6oCaZeZRp/Vw7EH8GBjnOXMBb6Xj5lj1lcAZHkhw6lSMetVZSQ==')
    end
  end
end
