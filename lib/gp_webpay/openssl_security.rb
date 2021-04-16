module GpWebpay
  module OpensslSecurity
    def self.generate_digest(configuration, digest_text)
      private_pem = OpenSSL::PKey::RSA.new(configuration.merchant_pem, configuration.merchant_password)
      sign = private_pem.sign(OpenSSL::Digest.new('SHA1'), digest_text)
      Base64.encode64(sign).gsub("\n", '')
    end

    # def self.validate_digests(configuration, data)
    #   public_pem = OpenSSL::X509::Certificate.new(configuration.gpe_pem).public_key
    #   data.all? do |received, expected|
    #     public_pem.verify(OpenSSL::Digest.new('SHA1'), Base64.decode64(received), expected)
    #   end
    # end
  end
end
