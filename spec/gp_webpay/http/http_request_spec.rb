require 'spec_helper'

RSpec.describe GpWebpay::Http::HttpRequest do
  subject { described_class.new(attributes) }
  let!(:attributes) do
    {
      order_number: 123,
      'merchant_number' => '1234567890',
      operation: 'CREATE_ORDER'
    }
  end

  it 'returns correct params and xml' do
    expect(subject.to_gpwebpay)
      .to eq('MERCHANTNUMBER' => '1234567890',
             'OPERATION' => 'CREATE_ORDER',
             'ORDERNUMBER' => 123)
  end

  context 'with additional info' do
    let!(:attributes) do
      {
        merchant_number: '1234567890',
        operation: 'CREATE_ORDER',
        order_number: 123,
        add_info: true
      }
    end
    describe '#to_gpwebpay' do
      it 'returns correct params and xml' do
        expect(subject.to_gpwebpay)
          .to eq('MERCHANTNUMBER' => '1234567890',
                 'OPERATION' => 'CREATE_ORDER',
                 'ORDERNUMBER' => 123,
                 'ADDINFO' => '<?xml version="1.0" encoding="UTF-8"?><additionalInfoRequest xmlns="http://gpe.cz/gpwebpay/additionalInfo/request" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="4.0"><requestReturnInfo><requestCardsDetails>true</requestCardsDetails></requestReturnInfo></additionalInfoRequest>')
      end
    end
  end
end
