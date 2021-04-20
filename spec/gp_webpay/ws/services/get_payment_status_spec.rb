require 'rails_helper'

RSpec.describe GpWebpay::Ws::Services::GetPaymentStatus, type: :webservice do
  before { savon.mock! }
  after { savon.unmock! }

  subject { described_class.call(params) }

  let!(:params) { { message_id: '131221', payment_number: '434984389984' } }

  context 'success with token' do
    it 'returns success object' do
      savon.expects(:get_payment_status).with(message: include(payment_status_request: anything))
        .returns('
                <?xml version="1.0" encoding="UTF-8"?>
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
                  <soapenv:Body>
                    <ns4:getPaymentStatusResponse xmlns:ns4="http://gpe.cz/pay/pay-ws/proc/v1" xmlns="http://gpe.cz/gpwebpay/additionalInfo/response" xmlns:ns5="http://gpe.cz/gpwebpay/additionalInfo/response/v1" xmlns:ns2="http://gpe.cz/pay/pay-ws/core/type" xmlns:ns3="http://gpe.cz/pay/pay-ws/proc/v1/type">
                      <ns4:paymentStatusResponse>
                        <ns3:messageId>1575392013=640549269</ns3:messageId>
                        <ns3:status>PS</ns3:status>
                        <ns3:signature>WRi6CWKYuYXSF6iejBdhkBgq+CnbOhkXhNyaw6NG7mdf33C1xCWeecyP6ZYbZ4LbOkKLm9v1z8L7WJsMzSK9qQ==</ns3:signature>
                      </ns4:paymentStatusResponse>
                    </ns4:getPaymentStatusResponse>
                  </soapenv:Body>
                </soapenv:Envelope>')
      expect(subject).to have_attributes(valid?: be_truthy,
                                         result_text: 'OK',
                                         status: 'PS',
                                         params: include(status: 'PS'))
    end
  end

  context 'http 500' do
    it 'returns false' do
      savon.expects(:get_payment_status).with(message: :any).returns(
        code: 500, headers: {}, body: ''
      )
      expect(subject.result_text).to eq "Internal HTTP request error: '500'"
    end
  end

  context 'soap fault' do
    it 'returns false' do
      savon.expects(:get_payment_status).with(message: :any).returns(
        '<?xml version="1.0" encoding="UTF-8"?>
           <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
             <soapenv:Body>
               <soapenv:Fault>
                 <faultcode>soapenv:Server</faultcode>
                 <faultstring>Invalid content something something.</faultstring>
                 <detail>
                   <ns4:serviceException xmlns:ns4="http://gpe.cz/pay/pay-ws/proc/v1" xmlns:ns5="http://gpe.cz/gpwebpay/additionalInfo/response/v1" xmlns:axis2ns1="http://gpe.cz/gpwebpay/additionalInfo/response" xmlns:ns2="http://gpe.cz/pay/pay-ws/core/type" xmlns:ns3="http://gpe.cz/pay/pay-ws/proc/v1/type">
                     <ns3:messageId>1163280052448799286</ns3:messageId>
                     <ns3:primaryReturnCode>7</ns3:primaryReturnCode>
                     <ns3:secondaryReturnCode>0</ns3:secondaryReturnCode>
                     <ns3:signature>Bewd7xD2wNI8Vy7egw0DGhH2f4cS5jSOx8ZR9ZCH0m7XzBCLXBp9vBNQsv2F0uShJuPsQF4d77crmDw+vdzAOA==</ns3:signature>
                   </ns4:serviceException>
                 </detail>
               </soapenv:Fault>
             </soapenv:Body>
           </soapenv:Envelope>'
      )
      expect(subject).to have_attributes(result_text: 'Invalid content something something.', valid?: be_truthy, success?: be_falsey)
    end
  end
end
