require 'rails_helper'

RSpec.describe GpWebpay::Ws::Services::ProcessUsageBasedPayment, type: :webservice do
  before { savon.mock! }
  after { savon.unmock! }

  subject { described_class.call(params) }

  let!(:params) do
    {}
  end

  context 'when everything is ok' do
    it 'returns ok' do
      savon.expects(:process_usage_based_payment).with(message: include(usage_based_payment_request: anything))
        .returns('
                <?xml version="1.0" encoding="UTF-8"?>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
                  <soapenv:Body>
                    <ns4:processUsageBasedPaymentResponse xmlns:ns4="http://gpe.cz/pay/pay-ws/proc/v1" xmlns="http://gpe.cz/gpwebpay/additionalInfo/response" xmlns:ns5="http://gpe.cz/gpwebpay/additionalInfo/response/v1" xmlns:ns2="http://gpe.cz/pay/pay-ws/core/type" xmlns:ns3="http://gpe.cz/pay/pay-ws/proc/v1/type">
                      <ns4:usageBasedPaymentResponse>
                        <ns3:messageId>1575299142=563023555</ns3:messageId>
                        <ns3:authCode>960777</ns3:authCode>
                        <ns3:tokenData>91F9EA5D9FE48E0F615A5E6686C547CBCFB85B7A1658E7B8533639DE08B3A9E5</ns3:tokenData>
                        <ns3:signature>acFyKyd+smt/E+rGcgOdcWUIe0bBwphRrMsh/C9VMHSs8Z3FjW7qZx5ewKWhg57dSL21/kbrlMF34V4H6tzEaA==</ns3:signature>
                      </ns4:usageBasedPaymentResponse>
                    </ns4:processUsageBasedPaymentResponse>
                  </soapenv:Body>
                </soapenv:Envelope>')
      expect(subject).to have_attributes(result_text: 'OK', valid?: be_truthy, success?: be_truthy,
                                         params: include(token_data: '91F9EA5D9FE48E0F615A5E6686C547CBCFB85B7A1658E7B8533639DE08B3A9E5'))

    end
  end

  context 'http 500' do
    it 'returns false' do
      savon.expects(:process_usage_based_payment).with(message: :any).returns(
        code: 500, headers: {}, body: ''
      )
      res = subject
      expect(res.result_text).to eq "Internal HTTP request error: '500'"
    end
  end

  context 'soap fault' do
    it 'returns false' do
      savon.expects(:process_usage_based_payment).with(message: :any).returns('
              <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
                <soapenv:Body>
                  <soapenv:Fault>
                    <faultcode>soapenv:Server</faultcode>
                    <faultstring>Signature not match</faultstring>
                    <detail>
                      <ns4:paymentServiceException xmlns:ns4="http://gpe.cz/pay/pay-ws/proc/v1" xmlns:ns5="http://gpe.cz/gpwebpay/additionalInfo/response/v1" xmlns:axis2ns29176="http://gpe.cz/gpwebpay/additionalInfo/response" xmlns:ns2="http://gpe.cz/pay/pay-ws/core/type" xmlns:ns3="http://gpe.cz/pay/pay-ws/proc/v1/type">
                        <ns3:messageId>1572340915=782949084</ns3:messageId>
                        <ns3:primaryReturnCode>31</ns3:primaryReturnCode>
                        <ns3:secondaryReturnCode>0</ns3:secondaryReturnCode>
                        <ns3:signature>hsSw34YXv/1XuNEEb5IDWI7I/pMMOZoUgZGEvLMW/O1lRjxX0q3R81+bTJ75NFxZ+WnpdRZq3VB65ZQUBb1y8w==</ns3:signature>
                      </ns4:paymentServiceException>
                    </detail>
                  </soapenv:Fault>
                </soapenv:Body>
              </soapenv:Envelope>')
      expect(subject).to have_attributes(result_text: 'Signature not match', valid?: be_truthy, success?: be_falsey)
    end
  end
end
