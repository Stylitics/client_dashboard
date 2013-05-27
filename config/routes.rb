require 'sidekiq/web'

Dashboard::Application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :users
    resources :r_scripts do
      delete :clear, on: :member
      put :activate, on: :member
      get :preview, on: :member
    end
    resources :r_script_runs

    root to: 'dashboard#index'
  end

  resources :charts do
    resources :chart_runs do
      get :check, on: :member
    end
  end

  get "/trends" => "dashboard#trends", as: :trends
  get "/brand-share" => "dashboard#brandshare", as: :brandshare
  get "/top-25-brands" => "dashboard#top25brands", as: :top25brands
  get "/top-25-retailers" => "dashboard#top25retailers", as: :top25retailers
  get "/top-10-colors-patterns-styles" => "dashboard#top10colorspatternsstyles", as: :top10colorspatternsstyles
  get "/outfit-stream-lookup" => "dashboard#outfitstreamlookup", as: :outfitstreamlookup
  get "/weather-visualizations" => "dashboard#weathervisualizations", as: :weathervisualizations

  root :to => 'dashboard#trends'

  mount Sidekiq::Web, at: '/sidekiq'
end
