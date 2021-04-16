require 'spec_helper'

RSpec.describe GpWebpay::Http::CreateOrder do
  subject do
    described_class.call(params, 'en')
  end

  context 'all attrs are present' do
    let(:params) do
      {
        order_number: 1,
        amount: 12.34,
        currency: 123,
        deposit_flag: 1,
        add_info: true
      }
    end

    it 'returns url and attributes with digest' do
      expect(subject.url).to eq 'https://test.3dsecure.gpwebpay.com/pgw/order.do'
      expect(subject.params)
        .to eq('ADDINFO' => '<?xml version="1.0" encoding="UTF-8"?><additionalInfoRequest xmlns="http://gpe.cz/gpwebpay/additionalInfo/request" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="4.0"><requestReturnInfo><requestCardsDetails>true</requestCardsDetails></requestReturnInfo></additionalInfoRequest>',
               'MERCHANTNUMBER' => '11111111',
               'OPERATION' => 'CREATE_ORDER',
               'ORDERNUMBER' => 1,
               'AMOUNT' => 12.34,
               'CURRENCY' => 123,
               'DEPOSITFLAG' => 1,
               'URL' => 'create-order-callback',
               'LANG' => 'en',
               'DIGEST' => 'IKc5kL3oIPhdsATpzDO2yfnu9JQfeuiJRe0pwobkP1Xcoadv43Qgku44IdbiVR1mL5BvUatuCmKFAzuq2/kTJg==')
    end
  end
end
