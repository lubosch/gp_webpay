require 'spec_helper'

RSpec.describe GpWebpay::Http::ValidateResult do
  subject { described_class.call(params, GpWebpay.config.default) }

  context 'correct digest' do
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
      expect(subject).to be_truthy
    end
  end

  context 'invalid digest' do
    let(:params) do
      {
        'OPERATION' => 'CREATE_ORDER',
        'ORDERNUMBER' => '123',
        'MERORDERNUM' => '',
        'MD' => '',
        'PRCODE' => '0',
        'SRCODE' => '0',
        'RESULTTEXT' => 'OK',
        'DIGEST' => 'not-valid',
        'DIGEST1' => 'not-valid'
      }
    end
    it 'returns false' do
      expect(subject).to be_falsey
    end
  end

  context 'missing digest' do
    let(:params) { {} }
    it 'returns false' do
      expect(subject).to be_falsey
    end
  end
end
