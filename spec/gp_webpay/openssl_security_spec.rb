require 'spec_helper'

RSpec.describe GpWebpay::OpensslSecurity do
  describe '.generate_digest' do
    subject { described_class.generate_digest(GpWebpay.config.default, 'Hello there') }
    it 'generates SHA1 digest' do
      expect(subject).to eq 'HsZliRmdaEIhNoTzEBHDN+OOP1oRSgIdMTNMFSxkUwtp5+9eGUqRvyFH7w+0wr3YXOXxqAlcXp7mKjN2Ma14+g=='
    end
  end

  # describe '.validate_digests' do
  #   subject do
  #     described_class.validate_digests(GpWebpay.config.default,
  #                                      'DIGEST' => 'HsZliRmdaEIhNoTzEBHDN+OOP1oRSgIdMTNMFSxkUwtp5+9eGUqRvyFH7w+0wr3YXOXxqAlcXp7mKjN2Ma14+g==',
  #                                      'DIGEST1' => 'HsZliRmdaEIhNoTzEBHDN+OOP1oRSgIdMTNMFSxkUwtp5+9eGUqRvyFH7w+0wr3YXOXxqAlcXp7mKjN2Ma14+g==')
  #   end
  #   it 'generates SHA1 digest' do
  #     expect(subject).to eq 'Hello there'
  #   end
  # end
end
