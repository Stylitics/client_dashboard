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
    resources :chart_runs
  end

  %w(trends brand-share top-25-brands-and-retailers top-10 outfit-stream weather).each do |r|
    get "/#{r}" => "dashboard##{r.underscore}", as: r.underscore.to_sym
  end

  root :to => 'dashboard#trends'
end
