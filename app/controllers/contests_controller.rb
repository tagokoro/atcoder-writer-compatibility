class ContestsController < ApplicationController
  CONTEST_TYPES = %w[ABC AGC ARC].freeze

  def get_latest_contest_id
    type = params[:type]

    return render json: { error: 'Invalid contest type' }, status: :bad_request unless CONTEST_TYPES.include?(type)

    contest_id = Contest.latest_id(type: type)
    render json: { contest_id: contest_id }
  end

  private

  def contest_params
    params.require(:contest).permit(:contest_type, :contest_id)
  end
end
