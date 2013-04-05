Dashboard::Application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :users
    resources :r_scripts

    root to: 'dashboard#index'
  end

  root :to => 'dashboard#index'
end
