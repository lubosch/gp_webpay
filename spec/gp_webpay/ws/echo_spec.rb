require 'rails_helper'

RSpec.describe GpWebpay::Ws::Echo, type: :webservice do
  include Savon::SpecHelper
  before { savon.mock! }
  after { savon.unmock! }

  subject { described_class.call }

  context 'success' do
    it 'returns true' do
      savon.expects(:echo)
        .returns(
          '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns4:echoResponse xmlns:ns4="http://gpe.cz/pay/pay-ws/proc/v1" xmlns="http://gpe.cz/gpwebpay/additionalInfo/response" xmlns:ns5="http://gpe.cz/gpwebpay/additionalInfo/response/v1" xmlns:ns2="http://gpe.cz/pay/pay-ws/core/type" xmlns:ns3="http://gpe.cz/pay/pay-ws/proc/v1/type"></ns4:echoResponse></soapenv:Body></soapenv:Envelope>'
        )
      expect(subject).to be_truthy
    end
  end

  context 'soap response missing' do
    it 'returns false' do
      savon.expects(:echo)
        .returns(
          '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body></soapenv:Body></soapenv:Envelope>'
        )
      expect(subject).to be_falsey
    end
  end

  context 'http 500' do
    it 'returns false' do
      savon.expects(:echo).returns(
        code: 500, headers: {}, body: ''
      )
      expect(subject).to be_falsey
    end
  end

  context 'soap fault' do
    it 'returns false' do
      savon.expects(:echo).returns(
        "<?xml version = '1.0' encoding = 'UTF-8'?> <SOAP-ENV:Envelope xmlns:SOAP-ENV = \"http://schemas.xmlsoap.org/soap/envelope/\"xmlns:xsi = \"http://www.w3.org/1999/XMLSchema-instance\"xmlns:xsd = \"http://www.w3.org/1999/XMLSchema\"> <SOAP-ENV:Body> <SOAP-ENV:Fault> <faultcode xsi:type = \"xsd:string\">SOAP-ENV:Client</faultcode> <faultstring xsi:type = \"xsd:string\"> Failed to locate method (ValidateCreditCard) in class (examplesCreditCard) at /usr/local/ActivePerl-5.6/lib/site_perl/5.6.0/SOAP/Lite.pm line 1555. </faultstring> </SOAP-ENV:Fault> </SOAP-ENV:Body> </SOAP-ENV:Envelope>"
      )
      expect(subject).to be_falsey
    end
  end
end
