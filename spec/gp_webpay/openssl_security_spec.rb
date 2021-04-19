require 'spec_helper'

RSpec.describe GpWebpay::OpensslSecurity do
  describe '.generate_digest' do
    subject { described_class.generate_digest(GpWebpay.config.default, 'Hello there') }
    it 'generates SHA1 digest' do
      expect(subject).to eq 'U7e7tvRf1LkyMblsLO97KZtzUp3JcPiN7pWhpy+su3zt2tgb6lJRxQzw2+w896K0ghoeedDFQZy3I1KcN61mMA=='
    end
  end

  describe '.validate_digests' do
    subject do
      described_class.validate_digests(GpWebpay.config.default,
                                       'U7e7tvRf1LkyMblsLO97KZtzUp3JcPiN7pWhpy+su3zt2tgb6lJRxQzw2+w896K0ghoeedDFQZy3I1KcN61mMA==' => 'Hello there')
    end
    it 'validates SHA1 digest' do
      expect(subject).to be_truthy
    end
  end
end
