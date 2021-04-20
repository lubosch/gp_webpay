require 'rails_helper'

RSpec.describe GpWebpay::Ws::ValidateResult do
  subject { described_class.call(params, GpWebpay.config.default) }

  context 'correct digest' do
    let(:params) do
      {
        message_id: 'message_id123456789',
        status: 'VERIFIED',
        non_digest_field: '32322',
        signature: 'mWBF6lOyYhBYSc+DFgpkNcR0f/TtNiMzsnDGrtPIhG9luBpUry6j2ZJfu6JqBuOXRh0mUYee+Hix3se5T6jEUg=='
      }
    end

    it 'returns true' do
      expect(subject).to be_truthy
    end
  end

  context 'invalid digest' do
    let(:params) do
      {
        message_id: 'message_id123456789',
        status: 'VERIFIED',
        signature: 'invalid'
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
