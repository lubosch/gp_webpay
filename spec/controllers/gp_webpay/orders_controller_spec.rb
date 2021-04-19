require 'rails_helper'

RSpec.describe GpWebpay::OrdersTestController, type: :controller do
  routes { GpWebpay::Engine.routes }

  context 'valid response' do
    let!(:params) do
      {
        'OPERATION' => 'CREATE_ORDER',
        'ORDERNUMBER' => '123123',
        'PRCODE' => '0',
        'SRCODE' => '0',
        'RESULTTEXT' => 'OK',
        'ADDINFO' => '<additionalInfoResponse xmlns="http://gpe.cz/gpwebpay/additionalInfo/response" version="3.0"><cardsDetails><cardDetail><brandName>VISA</brandName><expiryMonth>12</expiryMonth><expiryYear>2020</expiryYear><lastFour>0008</lastFour></cardDetail></cardsDetails></additionalInfoResponse>',
        'TOKEN' => "tokentoken",
        'PANPATTERN' => '************0008',
        'DIGEST' => 'VN1QtAcwyvu2/dkl0d17q6Ubqo9A44WSSe44jtsGPCovsIWvU4S20xCQ1lZNkFGaQDgfWg7+zdyFJQ0JOJyhSQ==',
        'DIGEST1' => 'cg4c6w7vrjArM+lf9xe4Z1XpuW4vBgUt8Wn0LOE2nVF3SAkV04hhgM6hIOr0EvfzP2wrlG1C/0/FsDr8fR9Bvw==',
      }
    end

    describe '#index' do
      it 'yields order number and response' do
        get :index, params: params
        expect(response).to have_http_status :redirect
        expect(response).to redirect_to "/123123"
      end

      context 'invalid response' do
        it 'returns 403' do
          get :index
          expect(response).to have_http_status :forbidden
        end
      end
    end

    describe '#create' do
      it 'yields order number and response' do
        post :create, params: params
        expect(response).to have_http_status :redirect
        expect(response).to redirect_to "/123123"
      end

      context 'invalid response' do
        it 'returns 403' do
          post :create
          expect(response).to have_http_status :forbidden
        end
      end
    end
  end
end
