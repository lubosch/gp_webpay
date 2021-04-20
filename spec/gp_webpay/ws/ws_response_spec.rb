require 'rails_helper'

RSpec.describe GpWebpay::Ws::WsResponse do
  describe '#from_success' do
    let(:message) do
      {
        get_token_status_response: {
          token_status_response: {
            status: 'EXPIRED',
            signature: 'M0cKHnun0jEXEHHbtgn5SfFR2rVAEa4K4/JQoGV36AqE4exWI1VLk0RcjJJzVwACFHR9LcIOC1ouHgc9C+1/2g=='
          }
        }
      }
    end
    subject do
      described_class.from_success(
        message,
        :get_token_status_response,
        :token_status_response,
        :default
      )
    end

    it 'transforms values to object instance' do
      expect(subject).to have_attributes(original_response: message,
                                         status: 'EXPIRED',
                                         result_text: 'OK',
                                         valid?: be_truthy,
                                         success?: be_truthy)
    end
  end

  describe '#from_fault_error' do
    subject { described_class.from_fault_error(message, :service_exception, :default) }
    let(:message) do
      {
        fault: {
          faultstring: 'MessageId must be at least 16 characters long.',
          detail: {
            service_exception: {
              error_code: '123',
              primary_return_code: '2',
              secondary_return_code: '4',
              signature: 'aedC3n1YgASbNeUEtVPlNBH2GUhRm+IqRUiQYD8m+zipPwQtxQILCjmzxm7Ivu7tflK/UoQaPNxr477r7ZA2jg=='
            }
          }
        }
      }
    end

    it 'transforms values to object instance' do
      expect(subject).to have_attributes(original_response: message,
                                         status: :error,
                                         result_text: 'MessageId must be at least 16 characters long.',
                                         pr_code: '2',
                                         sr_code: '4',
                                         valid?: be_truthy,
                                         success?: be_falsey)
    end
  end

  describe '#from_http_error' do
    subject { described_class.from_http_error(message, :default) }
    let(:message) { { code: '500' } }

    it 'transforms values to object instance' do
      expect(subject).to have_attributes(original_response: message,
                                         status: :error,
                                         result_text: "Internal HTTP request error: '500'",
                                         valid?: be_falsey,
                                         success?: be_falsey)
    end
  end
end
