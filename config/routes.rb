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

  root :to => 'dashboard#index'
end
