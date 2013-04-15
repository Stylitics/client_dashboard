Dashboard::Application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :users
    resources :r_scripts do
      delete :clear, on: :member
      put :activate, on: :member
    end
    resources :r_script_runs

    root to: 'dashboard#index'
  end

  resources :charts do
    resources :chart_runs
  end

  get "/trends" => "dashboard#trends", as: :trends

  root :to => 'dashboard#index'
end
