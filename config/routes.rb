Rails.application.routes.draw do
  get 'contests/latest/:type', only: [:get_latest_contest_id]
end
