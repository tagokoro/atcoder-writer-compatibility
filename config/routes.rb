Rails.application.routes.draw do
    resources :contests, only: [:create] do
      collection do
        get '/latest/:type', to: 'contests#get_latest_contest_id'
      end
    end
end
