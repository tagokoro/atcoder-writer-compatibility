class WritersController < ApplicationController
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
  def win_rate_params
    params.permit(:writer_name, :user_name, :contest_type)
  end
end
