require 'rails_helper'
require 'webmock/rspec'

RSpec.describe WritersController, type: :request do
  include FactoryBot::Syntax::Methods

  describe 'GET #win_rate' do
    let(:writer) { create(:writer, username: 'test_writer') }
    let(:contest) { create(:contest, contest_type: 'ABC', contest_id: 100) }

    before do
      create(:writer_contest, writer: writer, contest: contest)
    end

    context '正常系' do
      it '勝率が返される' do
        stub_request(:get, "https://atcoder.jp/users/tagokoro/history/json")
          .to_return(
            status: 200,
            body: [
              { "ContestScreenName" => "abc100", "OldRating" => 1000, "NewRating" => 1100 }
            ].to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        get "/writers/win_rate", params: { writer_name: 'test_writer', user_name: 'tagokoro', contest_type: 'ABC' }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['win_rate']).to eq(100.0)
      end
    end

    context '異常系' do
      it '存在しないwriterが入力されるとエラーが返される' do
        get "/writers/win_rate", params: { writer_name: 'unknown_writer', user_name: 'tagokoro', contest_type: 'ABC' }

        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json['error']).to be_present
      end

      it '存在しないuserが入力されると勝率0が返される' do
        stub_request(:get, "https://atcoder.jp/users/tagokoro/history/json")
          .to_return(
            status: 200,
            body: [].to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        get "/writers/win_rate", params: { writer_name: 'test_writer', user_name: 'unknown_user', contest_type: 'ABC' }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['win_rate']).to eq(0)
      end
    end
  end
end
