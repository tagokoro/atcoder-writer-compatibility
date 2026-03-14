Rails.application.routes.draw do
    resources :contests, only: [:create] do
      collection do
        get '/latest/:type', to: 'contests#get_latest_contest_id'
      end
    end

    resources :writers, only: [:index], param: :writer_name do
      member do
        get :win_rate, to: 'contests#win_rate'
      end
    end
end
