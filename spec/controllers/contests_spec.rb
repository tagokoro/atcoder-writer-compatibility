require 'rails_helper'

RSpec.describe ContestsController, type: :request do
  include FactoryBot::Syntax::Methods

  let!(:contest) { create(:contest, contest_type: 'ABC', contest_id: 100) }

  describe 'GET #get_latest_contest_id' do
    context '正常系' do
      it '最新のコンテストIDが返される' do
        get '/contests/latest/ABC'

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['contest_id']).to eq 100
      end
    end

    context '異常系' do
      it '存在しないコンテストタイプが指定されると何も返されない' do
        get '/contests/latest/AXC'

        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
