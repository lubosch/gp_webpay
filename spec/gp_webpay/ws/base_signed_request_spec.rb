require 'rails_helper'

class WsBaseSignedRequestKlass < GpWebpay::Ws::BaseSignedRequest
  OPERATION_NAME = :process_usage_based_payment
  REQUEST_NAME = :usage_based_payment_request
  RESPONSE_NAME = :process_usage_based_payment_response
  RESPONSE_ENTITY_NAME = :usage_based_payment_response
  SERVICE_EXCEPTION = :usage_based_payment_exception
end

RSpec.describe GpWebpay::Ws::BaseSignedRequest, type: :webservice do
  subject { WsBaseSignedRequestKlass.call(attributes, merchant_number: :default) }
  before { savon.mock! }
  after { savon.unmock! }

  let!(:attributes) do
    {
      order_number: 123,
      'merchant_number' => '1234567890',
      amount: 4333,
      spam: 'ignore'
    }
  end

  context 'when no authentication is required' do
    it 'returns ok' do
      savon.expects(:process_usage_based_payment)
        .with(message: {
                usage_based_payment_request: { 'ins0:orderNumber' => 123,
                                               'ins0:merchantNumber' => '11111111',
                                               'ins0:provider' => '3040',
                                               'ins0:amount' => 4333,
                                               'ins0:signature' => 'iLFSMdLXigVs5FV1Ov5IYtuzm+OMasvh+4ywYhhf+2drCOvqjqyqd8hpavH7srnDlxvz/41n1Ky7xhMrYXa/Eg==' }
              }).returns('
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
      expect(subject)
        .to have_attributes(valid?: be_truthy,
                            result_text: 'OK',
                            success?: be_truthy,
                            params: include(auth_code: '960777',
                                            message_id: '1575299142=563023555',
                                            token_data: '91F9EA5D9FE48E0F615A5E6686C547CBCFB85B7A1658E7B8533639DE08B3A9E5'))
    end
  end

  context 'http 500' do
    it 'returns false' do
      savon.expects(:process_usage_based_payment).with(message: :any).returns(code: 500, headers: {}, body: '')
      expect(subject.result_text).to eq "Internal HTTP request error: '500'"
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
                      <ns4:usageBasedPaymentException xmlns:ns4="http://gpe.cz/pay/pay-ws/proc/v1" xmlns:ns5="http://gpe.cz/gpwebpay/additionalInfo/response/v1" xmlns:axis2ns29176="http://gpe.cz/gpwebpay/additionalInfo/response" xmlns:ns2="http://gpe.cz/pay/pay-ws/core/type" xmlns:ns3="http://gpe.cz/pay/pay-ws/proc/v1/type">
                        <ns3:messageId>1572340915=782949084</ns3:messageId>
                        <ns3:primaryReturnCode>31</ns3:primaryReturnCode>
                        <ns3:secondaryReturnCode>0</ns3:secondaryReturnCode>
                        <ns3:signature>NQtkX2K7JK0Giq08Voj0tmqftUrsx9JbexMY1HbbqGbu6BN0OXbr/DdK/49sZMSmkKjIbAkXk/EuKMKNxEMQ/w==</ns3:signature>
                      </ns4:usageBasedPaymentException>
                    </detail>
                  </soapenv:Fault>
                </soapenv:Body>
              </soapenv:Envelope>')
      expect(subject.result_text).to eq 'Signature not match'
    end
  end
end
