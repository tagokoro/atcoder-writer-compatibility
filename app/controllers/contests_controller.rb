class ContestsController < ApplicationController
  def create
    contest = Contest.new(contest_params)

    if contest.save
      render json: contest, status: :created
    else
      render json: { errors: contest.errors.full_messages }, status: :unprocessable_entity
    end
  end
  def get_latest_contest_id
    type = params[:type]
    contest_id = Contest.latest_id(type: type)
    render json: { contest_id: contest_id }
  end

  private
  def contest_params
    params.require(:user).permit(:contest_type, :contest_id)
  end
end
