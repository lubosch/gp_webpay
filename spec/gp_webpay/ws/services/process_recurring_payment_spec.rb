require 'rails_helper'

RSpec.describe GpWebpay::Ws::Services::ProcessRecurringPayment, type: :webservice do
  before { savon.mock! }
  after { savon.unmock! }

  subject { described_class.call(params) }

  let!(:params) { {} }

  context 'when everything is ok' do
    it 'returns ok' do
      savon.expects(:process_recurring_payment).with(message: include(recurring_payment_request: anything))
        .returns('
                <?xml version="1.0" encoding="UTF-8"?>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
                  <soapenv:Body>
                    <ns4:processRecurringPaymentResponse xmlns:ns4="http://gpe.cz/pay/pay-ws/proc/v1" xmlns="http://gpe.cz/gpwebpay/additionalInfo/response" xmlns:ns5="http://gpe.cz/gpwebpay/additionalInfo/response/v1" xmlns:ns2="http://gpe.cz/pay/pay-ws/core/type" xmlns:ns3="http://gpe.cz/pay/pay-ws/proc/v1/type">
                      <ns4:recurringPaymentResponse>
                        <ns3:messageId>1575390922=494537711</ns3:messageId>
                        <ns3:authCode>379566</ns3:authCode>
                        <ns3:signature>v69dH7/7PkEJdzvY08SBLpbCBqAXRjaIxtCpKKFUJlDwv8/8G3vxNjZNARGUw30/ELm3Zj0qenB9zHHyJV12ew==</ns3:signature>
                      </ns4:recurringPaymentResponse>
                    </ns4:processRecurringPaymentResponse>
                  </soapenv:Body>
                </soapenv:Envelope>')
      expect(subject).to have_attributes(result_text: 'OK', valid?: be_truthy, success?: be_truthy)
    end
  end

  context 'http 500' do
    it 'returns false' do
      savon.expects(:process_recurring_payment).with(message: :any).returns(
        code: 500, headers: {}, body: ''
      )
      res = subject
      expect(res.result_text).to eq "Internal HTTP request error: '500'"
    end
  end

  context 'soap fault' do
    it 'returns false' do
      savon.expects(:process_recurring_payment).with(message: :any).returns('
              <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
                <soapenv:Body>
                  <soapenv:Fault>
                    <faultcode>soapenv:Server</faultcode>
                    <faultstring>Signature not match</faultstring>
                    <detail>
                      <ns4:serviceException xmlns:ns4="http://gpe.cz/pay/pay-ws/proc/v1" xmlns:ns5="http://gpe.cz/gpwebpay/additionalInfo/response/v1" xmlns:axis2ns29176="http://gpe.cz/gpwebpay/additionalInfo/response" xmlns:ns2="http://gpe.cz/pay/pay-ws/core/type" xmlns:ns3="http://gpe.cz/pay/pay-ws/proc/v1/type">
                        <ns3:messageId>1572340915=782949084</ns3:messageId>
                        <ns3:primaryReturnCode>31</ns3:primaryReturnCode>
                        <ns3:secondaryReturnCode>0</ns3:secondaryReturnCode>
                        <ns3:signature>hsSw34YXv/1XuNEEb5IDWI7I/pMMOZoUgZGEvLMW/O1lRjxX0q3R81+bTJ75NFxZ+WnpdRZq3VB65ZQUBb1y8w==</ns3:signature>
                      </ns4:serviceException>
                    </detail>
                  </soapenv:Fault>
                </soapenv:Body>
              </soapenv:Envelope>')
      expect(subject).to have_attributes(result_text: 'Signature not match', valid?: be_truthy, success?: be_falsey)
    end
  end
end
