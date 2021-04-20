require 'rails_helper'

RSpec.describe GpWebpay::Http::HttpResponse do
  subject { described_class.from_hash(params, GpWebpay.config.default) }
  describe '#from_hash' do
    let!(:params) do
      {
        'OPERATION' => 'CREATE_ORDER',
        'ORDERNUMBER' => '123',
        'PRCODE' => '123',
        'SRCODE' => '0',
        'RESULTTEXT' => 'OK',
        'TOKEN' => 'token',
        'ADDINFO' => '<additionalInfoResponse xmlns="http://gpe.cz/gpwebpay/additionalInfo/response" version="3.0"><cardsDetails><cardDetail><brandName>VISA</brandName><expiryMonth>12</expiryMonth><expiryYear>2020</expiryYear><lastFour>0008</lastFour></cardDetail></cardsDetails></additionalInfoResponse>'
      }
    end

    it 'transforms values to object instance' do
      res = subject
      expect(res.params).to include(operation: 'CREATE_ORDER', order_number: '123', pr_code: '123', sr_code: '0', result_text: 'OK', token: 'token',
                                    add_info: include('additionalInfoResponse' => include('cardsDetails' => include('cardDetail' => { 'brandName' => 'VISA', 'expiryMonth' => '12', 'expiryYear' => '2020', 'lastFour' => '0008' }))))
      expect(res.original_response['OPERATION']).to eq 'CREATE_ORDER'
      expect(res).to have_attributes(pr_code: '123', sr_code: '0', result_text: 'OK', token: 'token', config: GpWebpay.config.default)
    end

    context 'when success response' do
      let(:params) do
        { 'PRCODE' => '0', 'SRCODE' => '0', 'RESULTTEXT' => 'OK' }
      end

      it 'is success' do
        expect(subject.success?).to be_truthy
        expect(subject.result_text).to eq 'OK'
      end
    end

    context 'with error response' do
      let(:params) do
        { 'PRCODE' => '123', 'SRCODE' => '0', 'RESULTTEXT' => 'Error' }
      end

      it 'is no success' do
        expect(subject.success?).to be_falsey
        expect(subject.result_text).to eq 'Error'
      end
    end
  end

  describe '#valid' do
    context 'when digest is correct' do
      let(:params) do
        {
          'OPERATION' => 'CREATE_ORDER',
          'ORDERNUMBER' => '123',
          'MERORDERNUM' => '',
          'MD' => '',
          'PRCODE' => '0',
          'SRCODE' => '0',
          'RESULTTEXT' => 'OK',
          'DIGEST' => 'Uv1t80I98wP+JWgPtz9TNZIABkW+YvjLvz+5VlTrlCCf4Dqgu6URUeXRNW/Cm531CTUbgttjL27L/V+PVP5yEQ==',
          'DIGEST1' => 'YwfOIwg3ZQwxBGTI+RZk9nUPHQPUYQmV0gIO8AFJzwTxx6znjWU43VVU1EujpQTBrFyvJzteLSfntm+kKE/aqQ=='
        }
      end
      it 'returns true' do
        expect(subject.valid?).to be_truthy
      end
    end
    context 'when invalid digest' do
      let(:params) do
        {
          'OPERATION' => 'CREATE_ORDER',
          'ORDERNUMBER' => '123',
          'MERORDERNUM' => '',
          'MD' => '',
          'PRCODE' => '0',
          'SRCODE' => '0',
          'RESULTTEXT' => 'OK',
          'DIGEST' => 'Uv1t80I98wP+JWgPtz9TNZIABkW+YvjLvz+5VlTrlCCf4Dqgu6URUeXRNW/Cm531CTUbgttjL27L/V+PVP5yEQ==',
          'DIGEST1' => 'invalid'
        }
      end
      it 'returns false' do
        expect(subject.valid?).to be_falsey
      end
    end
  end
end
