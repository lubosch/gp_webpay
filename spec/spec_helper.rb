require_relative 'support/simplecov'

require 'bundler/setup'
require 'gp_webpay'
require 'webmock/rspec'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

GpWebpay.configure do |config|
  config.add_configuration(merchant_number: '11111111') do |merchant_config|
    merchant_config.merchant_number = '11111111'
    merchant_config.merchant_pem = "-----BEGIN RSA PRIVATE KEY-----\nMIIBOAIBAAJAe/YQlNxd17ZEGP0fMjcOgZAdUxs32R/PW251qngTuTRgV6YCuKzx\nii7hadHE9n6mHdIC8Wt8UMGi0i38sLrzywIDAQABAkBVguvzVITj3lbhihMwF6zJ\nEbo47yi6fegT4YIIA2dPtWOD310ZK9mnUe9SKoJg3lu8rkSR1m7QaHASXb0uZKD5\nAiEA6ysB0xQM/t4vu46xiRJf98ohjETIyaAnCDRaXwgdBU8CIQCG8S3fQ+cDsVDw\nup4x9mIYqKaZEX3tWAc874zY7aDCxQIgYdbYwXq8FWVXMo8hacfNSYg9AOC1ML2C\nv7UYTCVR/Z0CIEeEGKikBxII7nm2ndKi3phtAWZMQ+3+4k8kMgRh4/p1AiBSYE6x\nCjD9B1eq53/d8HKbWWmSSmJ/6SqnS7dk7KESQA==\n-----END RSA PRIVATE KEY-----"
    merchant_config.merchant_password = 'Password'
    merchant_config.gpe_pem = "-----BEGIN CERTIFICATE-----\nMIIC1TCCAb2gAwIBAgIJAKx2bvZvCYtAMA0GCSqGSIb3DQEBBQUAMBoxGDAWBgNV\nBAMTD3d3dy5leGFtcGxlLmNvbTAeFw0yMTA0MTUxMTI2NDNaFw0zMTA0MTMxMTI2\nNDNaMBoxGDAWBgNVBAMTD3d3dy5leGFtcGxlLmNvbTCCASIwDQYJKoZIhvcNAQEB\nBQADggEPADCCAQoCggEBALymrgbgi4xRPCS8hCC0ILiybgPBenXoi6+iPunaDgxz\nqZU940j5nXSZJ3sNdaU+3gR+yi6NidOWO/L/DymrBvi8obbeG72sZ2Y0KE7CfYjw\ngyxX0/qxaz5FdvMbgeIz3F1o9UD52JFtns9l0fHH61iJu9vK0F3jP+eBNe12320j\nASXg9hTrhU3LYmCqdWptOsS9psyWhLo8Z4GZuj3cnaTUAdQxVP9VD/0lGoN5oMcb\nOJRas4mp7HX3f6c2pJgjjL98Zjs5P5HLvD96tGBnNGWDyad7U0GqxOAJ3ABBr9kv\nM75mIa+gSuCrCNlGxIldh2qvei3nTTiK/6kWHu+pKIECAwEAAaMeMBwwGgYDVR0R\nBBMwEYIPd3d3LmV4YW1wbGUuY29tMA0GCSqGSIb3DQEBBQUAA4IBAQApqHpG3lJ9\nH2kqEjAeYE4dZtKbuY6Dj2URdD46tDHDo8Qac0qQD3zi5NbhB91v8BNrW3D4N34V\nWOtFx1OJYV6nzCqpTxTVike9oUtPbUR+9j2ZfvEesfy/2OGSQ/33zc/B5EgwDw5j\n3tHXFcQxfaJ6gELn3s7PR43v68y6+YQIReHcTpgahs+/I4FvuA32o5H1/RMmUcWL\nVV9i3qqH9zh+k0MEj6PFHKDcnlVDaS9CQsJwuvy1OU1rsytfc6NfeBRvtMi/cgNw\n3o7WEUAjPqUzANMMh0+d05J2LyNfXlxTwD6q4KZ3DHtRIWJPKxHf9E63+tDEIAgR\nC6xJDHHtQL75\n-----END CERTIFICATE-----\n"
    merchant_config.provider = '3040'
  end
end
