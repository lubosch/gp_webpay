require 'rails_helper'

RSpec.describe GpWebpay::Ws::Services::ProcessMasterPaymentRevoke, type: :webservice do
  before { savon.mock! }
  after { savon.unmock! }

  subject { described_class.call(params) }

  let!(:params) { { message_id: '131221', payment_number: '434984389984' } }

  context 'when everything is ok' do
    it 'returns ok' do
      savon.expects(:process_master_payment_revoke).with(message: include(master_payment_revoke_request: anything))
        .returns('
                <?xml version="1.0" encoding="UTF-8"?>
                  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
                    <soapenv:Body>
                      <ns4:processMasterPaymentRevokeResponse xmlns:ns4="http://gpe.cz/pay/pay-ws/proc/v1" xmlns="http://gpe.cz/gpwebpay/additionalInfo/response" xmlns:ns5="http://gpe.cz/gpwebpay/additionalInfo/response/v1" xmlns:ns2="http://gpe.cz/pay/pay-ws/core/type" xmlns:ns3="http://gpe.cz/pay/pay-ws/proc/v1/type">
                        <ns4:masterPaymentStatusResponse>
                          <ns3:messageId>1575391770=275096923</ns3:messageId>
                          <ns3:status>CM</ns3:status>
                          <ns3:signature>tqx2NE7wxHH6fKmldU6t3SwsaHymTcOfhhSccAEyGq68ZPOmabQ9Oz2HrqeGavGG2zZE8T5uylzty1HeMzKmeA==</ns3:signature>
                        </ns4:masterPaymentStatusResponse>
                      </ns4:processMasterPaymentRevokeResponse>
                    </soapenv:Body>
                  </soapenv:Envelope>')
      expect(subject).to have_attributes(status: 'CM', result_text: 'OK', valid?: be_truthy, success?: be_truthy)
    end
  end

  context 'http 500' do
    it 'returns false' do
      savon.expects(:process_master_payment_revoke).with(message: :any).returns(
        code: 500, headers: {}, body: ''
      )
      res = subject
      expect(res.result_text).to eq "Internal HTTP request error: '500'"
    end
  end

  context 'soap fault' do
    it 'returns false' do
      savon.expects(:process_master_payment_revoke).with(message: :any).returns('
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
