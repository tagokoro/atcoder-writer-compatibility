class ContestsController < ApplicationController
  def get_latest_contest_id
    type = params[:type]
    contest_id = Contest.latest_id(type: type)
    render json: { contest_id: contest_id }
  end
  def win_rate
    result = WriterWinRateCalculator.new(
      writer_name: win_rate_params[:writer_name],
      user_name: win_rate_params[:user_name],
      contest_type: win_rate_params[:contest_type]
    ).calculate

    if result.nil?
      render json: { error: "勝率の計算に失敗しました" }, status: :bad_request
    else
      render json: { win_rate: result }
    end
  end

  private
  def contest_params
    params.require(:user).permit(:contest_type, :contest_id)
  end

  def win_rate_params
    params.permit(:writer_name, :user_name, :contest_type)
  end
end
