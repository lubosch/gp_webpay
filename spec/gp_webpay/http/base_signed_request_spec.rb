require 'spec_helper'

class Klass < GpWebpay::Http::BaseSignedRequest
  def callback_url
    'callback_url'
  end
end

RSpec.describe GpWebpay::Http::BaseSignedRequest do
  subject { Klass.call(attributes, 'en', 'CREATE_ORDER', merchant_number: :default) }
  let(:attributes) do
    {
      order_number: 123,
      currency: 230,
      paymethods: 'CRD',
      amount: 1212,
      add_info: true
    }
  end

  it 'generates gp webpay link' do
    expect(subject.url).to eq 'https://test.3dsecure.gpwebpay.com/pgw/order.do'
    expect(subject.params)
      .to eq('ADDINFO' => '<?xml version="1.0" encoding="UTF-8"?><additionalInfoRequest xmlns="http://gpe.cz/gpwebpay/additionalInfo/request" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="4.0"><requestReturnInfo><requestCardsDetails>true</requestCardsDetails></requestReturnInfo></additionalInfoRequest>',
             'MERCHANTNUMBER' => '11111111',
             'OPERATION' => 'CREATE_ORDER',
             'ORDERNUMBER' => 123,
             'AMOUNT' => 1212,
             'CURRENCY' => 230,
             'URL' => 'callback_url',
             'PAYMETHODS' => 'CRD',
             'DIGEST' => 'aX79sL0IZz9SQlPdBVxhKaZn+ygc45XptXzQJXrBcscQUFSmCkUbqI3F/A53U/5UbGGnYCdTmOe8zMyexGxsYQ==',
             'LANG' => 'en')
  end
end
