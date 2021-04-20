require 'rails_helper'

RSpec.describe GpWebpay::Ws::WsRequest do
  subject { described_class.new(attributes) }
  let!(:attributes) do
    {
      order_number: 123,
      'merchant_number' => '1234567890',
      amount: 4333,
      spam: 'ignore'
    }
  end

  it 'returns correct params and xml' do
    expect(subject.to_gpwebpay)
      .to eq('ins0:orderNumber' => 123,
             'ins0:merchantNumber' => '1234567890',
             'ins0:amount' => 4333)
  end
end
