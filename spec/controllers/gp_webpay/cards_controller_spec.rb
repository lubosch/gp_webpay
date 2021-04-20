require 'rails_helper'

RSpec.describe GpWebpay::CardsTestController, type: :controller do
  routes { GpWebpay::Engine.routes }

  context 'valid response' do
    let!(:params) do
      {
        'OPERATION' => 'CARD_VERIFICATION',
        'ORDERNUMBER' => '123123',
        'PRCODE' => '0',
        'SRCODE' => '0',
        'RESULTTEXT' => 'OK',
        'ADDINFO' => '<additionalInfoResponse xmlns="http://gpe.cz/gpwebpay/additionalInfo/response" version="3.0"><cardsDetails><cardDetail><brandName>VISA</brandName><expiryMonth>12</expiryMonth><expiryYear>2020</expiryYear><lastFour>0008</lastFour></cardDetail></cardsDetails></additionalInfoResponse>',
        'TOKEN' => 'tokentoken',
        'PANPATTERN' => '************0008',
        'DIGEST' => 'qNnC8Arw+Rv+uCbD3a9BzTQPnCfwyCWtrnlz1VFyBbvuSMRN0JdM7me3mIJLEFqhQqn0YqKSVlLGFmA2lQx8fw==',
        'DIGEST1' => 'DHGQ1IH8MwxcXJFhbRaMfN+vr3O3b2xZqlFVDLUBkdPHokp1SyQPbnzrkDdwJoyR5R6Krph866GpozXaAE3v1Q=='
      }
    end

    describe '#index' do
      it 'yields order number and response' do
        get :index, params: params
        expect(response).to have_http_status :redirect
        expect(response).to redirect_to '/123123'
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
        expect(response).to redirect_to '/123123'
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
