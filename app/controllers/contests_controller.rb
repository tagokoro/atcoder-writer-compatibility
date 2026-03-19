class ContestsController < ApplicationController
  def get_latest_contest_id
    type = params[:type]
    contest_id = Contest.latest_id(type: type)
    render json: { contest_id: contest_id }
  end

  private
  def contest_params
    params.require(:contest).permit(:contest_type, :contest_id)
  end
end
