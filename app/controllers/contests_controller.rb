class ContestsController < ApplicationController
  def get_latest_contest_id
    type = params[:type]
    contest_id = Contest.latest_id(type: type)
    render json: { contest_id: contest_id }
  end
end
