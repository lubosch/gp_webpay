require 'rails_helper'

RSpec.describe GpWebpay::Ws::Services::ProcessCardOnFilePayment, type: :webservice do
  include Savon::SpecHelper
  before { savon.mock! }
  after { savon.unmock! }

  subject { described_class.call(params) }

  let!(:params) do
    {}
  end

  context 'when authentication is required' do
    it 'raises error' do
      savon.expects(:process_card_on_file_payment).with(message: include(card_on_file_payment_request: anything))
        .returns(
          '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
                  <soapenv:Body>
                    <soapenv:Fault>
                      <faultcode>soapenv:Server</faultcode>
                      <faultstring>No authorized</faultstring>
                      <detail>
                        <ns4:cardOnFilePaymentServiceException xmlns:ns4="http://gpe.cz/pay/pay-ws/proc/v1" xmlns:ns5="http://gpe.cz/gpwebpay/additionalInfo/response/v1" xmlns:axis2ns29175="http://gpe.cz/gpwebpay/additionalInfo/response" xmlns:ns2="http://gpe.cz/pay/pay-ws/core/type" xmlns:ns3="http://gpe.cz/pay/pay-ws/proc/v1/type">
                          <ns3:messageId>1572340661=053579037</ns3:messageId>
                          <ns3:primaryReturnCode>46</ns3:primaryReturnCode>
                          <ns3:secondaryReturnCode>300</ns3:secondaryReturnCode>
                          <ns3:signature>MBbUcuxOxY1qZDUCSpOpvkdIfmqVJUmflA15mPf9PUTe9xCxDUsTxJZT3QWDX+e+2OSLiEIFXIshGNvfED8Lgw==</ns3:signature>
                          <ns3:authenticationLink>https://test.3dsecure.gpwebpay.com/pgw/pay/izhaFVjCtB</ns3:authenticationLink>
                        </ns4:cardOnFilePaymentServiceException>
                      </detail>
                    </soapenv:Fault>
                  </soapenv:Body>
                </soapenv:Envelope>'
        )
      expect { subject }.to raise_error(described_class::GpWebpayConfirmationRequired).with_message('GP Webpay requires authentication') do |error|
        expect(error.authentication_link).to eq 'https://test.3dsecure.gpwebpay.com/pgw/pay/izhaFVjCtB'
      end
    end
  end

  context 'when no authentication is required' do
    it 'returns ok' do
      savon.expects(:process_card_on_file_payment).with(message: :any)
        .returns('
              <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
                  <soapenv:Body>
                    <ns4:processCardOnFilePaymentResponse xmlns:ns4="http://gpe.cz/pay/pay-ws/proc/v1" xmlns="http://gpe.cz/gpwebpay/additionalInfo/response" xmlns:ns5="http://gpe.cz/gpwebpay/additionalInfo/response/v1" xmlns:ns2="http://gpe.cz/pay/pay-ws/core/type" xmlns:ns3="http://gpe.cz/pay/pay-ws/proc/v1/type">
                      <ns4:cardOnFilePaymentResponse>
                        <ns3:messageId>1572341589=654333641</ns3:messageId>
                        <ns3:authCode>617549</ns3:authCode>
                        <ns3:tokenData>91F9EA5D9FE48E0F615A5E6686C547CBCFB85B7A1658E7B8533639DE08B3A9E5</ns3:tokenData>
                        <ns3:signature>BzXKvxyvNlNOSM8cOcd7vIxD65Z8uLADVtaWMK+N9BT5DupLT4Vg1PQgLppwUIvOXbT8ICr3ruNBM9P1MNMAiw==</ns3:signature>
                      </ns4:cardOnFilePaymentResponse>
                    </ns4:processCardOnFilePaymentResponse>
                  </soapenv:Body>
                </soapenv:Envelope>')
      expect(subject).to have_attributes(result_text: 'OK', valid?: be_truthy, success?: be_truthy,
                                         params: include(token_data: '91F9EA5D9FE48E0F615A5E6686C547CBCFB85B7A1658E7B8533639DE08B3A9E5'))
    end
  end

  context 'http 500' do
    it 'returns false' do
      savon.expects(:process_card_on_file_payment).with(message: :any).returns(
        code: 500, headers: {}, body: ''
      )
      res = subject
      expect(res.result_text).to eq "Internal HTTP request error: '500'"
    end
  end

  context 'soap fault' do
    it 'returns false' do
      savon.expects(:process_card_on_file_payment).with(message: :any).returns('
              <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
                <soapenv:Body>
                  <soapenv:Fault>
                    <faultcode>soapenv:Server</faultcode>
                    <faultstring>Signature not match</faultstring>
                    <detail>
                      <ns4:cardOnFilePaymentServiceException xmlns:ns4="http://gpe.cz/pay/pay-ws/proc/v1" xmlns:ns5="http://gpe.cz/gpwebpay/additionalInfo/response/v1" xmlns:axis2ns29176="http://gpe.cz/gpwebpay/additionalInfo/response" xmlns:ns2="http://gpe.cz/pay/pay-ws/core/type" xmlns:ns3="http://gpe.cz/pay/pay-ws/proc/v1/type">
                        <ns3:messageId>1572340915=782949084</ns3:messageId>
                        <ns3:primaryReturnCode>31</ns3:primaryReturnCode>
                        <ns3:secondaryReturnCode>0</ns3:secondaryReturnCode>
                        <ns3:signature>hsSw34YXv/1XuNEEb5IDWI7I/pMMOZoUgZGEvLMW/O1lRjxX0q3R81+bTJ75NFxZ+WnpdRZq3VB65ZQUBb1y8w==</ns3:signature>
                      </ns4:cardOnFilePaymentServiceException>
                    </detail>
                  </soapenv:Fault>
                </soapenv:Body>
              </soapenv:Envelope>')
      expect(subject).to have_attributes(result_text: 'Signature not match', valid?: be_truthy, success?: be_falsey)
    end
  end
end
