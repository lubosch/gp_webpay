require 'rails_helper'

RSpec.describe GpWebpay::Ws::Services::ProcessRefundPayment, type: :webservice do
  before { savon.mock! }
  after { savon.unmock! }

  subject { described_class.call(params) }

  let!(:params) do
    {}
  end

  context 'when no authentication is required' do
    it 'returns ok' do
      savon.expects(:process_refund).with(message: include(refund_request: anything))
        .returns('
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
                  <soapenv:Body>
                    <ns4:processRefundResponse xmlns:ns4="http://gpe.cz/pay/pay-ws/proc/v1" xmlns:ns2="http://gpe.cz/pay/pay-ws/core/type" xmlns="http://gpe.cz/gpwebpay/additionalInfo/response" xmlns:ns3="http://gpe.cz/pay/payws/proc/v1/type" xmlns:ns5="http://gpe.cz/gpwebpay/additionalInfo/response/v1">
                      <ns4:refundRequestResponse>
                        <ns3:messageId>1597665317=231069202</ns3:messageId>
                        <ns3:state>11</ns3:state>
                        <ns3:status>REFUNDED</ns3:status>
                        <ns3:subStatus>PENDING_REFUND_SETTLEMENT</ns3:subStatus>
                        <ns3:signature>BESXPCbT6GnBvtzD5YrTtk030FvHLdUaGFgYEsSn6wQ+uk6FLrO+uCSEsHJuLroYZHgGLvMht2h/ylHoQB+46w==</ns3:signature>
                      </ns4:refundRequestResponse>
                    </ns4:processRefundResponse>
                  </soapenv:Body>
                </soapenv:Envelope>')
      expect(subject).to have_attributes(status: 'REFUNDED', result_text: 'OK', valid?: be_truthy, success?: be_truthy,
                                         params: include(sub_status: 'PENDING_REFUND_SETTLEMENT', state: '11'))
    end
  end

  context 'http 500' do
    it 'returns false' do
      savon.expects(:process_refund).with(message: :any).returns(
        code: 500, headers: {}, body: ''
      )
      res = subject
      expect(res.result_text).to eq "Internal HTTP request error: '500'"
    end
  end

  context 'soap fault' do
    it 'returns false' do
      savon.expects(:process_refund).with(message: :any).returns('
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
