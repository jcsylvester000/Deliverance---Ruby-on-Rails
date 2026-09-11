Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  # Health check (Rails default).
  get "up" => "rails/health#show", as: :rails_health_check

  # The HUD "setting up your dashboard" interstitial shown right after sign-up.
  get "setting-up", to: "pages#setting_up", as: :setting_up

  # Marketing pages (Phase 10).
  get "about",    to: "pages#about",      as: :about
  get "why-join", to: "pages#membership", as: :membership

  # Blog (static content — see app/models/article.rb).
  resources :articles, only: [:index, :show], path: "blog"

  # Public job board.
  resources :jobs, only: [:index, :show]

  # In-app notifications (any signed-in user).
  resources :notifications, only: [:index]

  # Messaging (any signed-in user).
  resources :conversations, only: [:index, :show, :create] do
    member do
      patch :accept
      patch :decline
      patch :block
    end
    resources :messages, only: [:create]
  end

  # Poster area.
  namespace :poster do
    resource :dashboard, only: [:show], controller: "dashboards"
    resources :job_postings do
      member { patch :close }
    end
    resources :applications, only: [:index, :show] do
      member do
        patch :advance
        patch :reject
      end
    end
    resources :interviews, only: [:index, :new, :create, :edit, :update] do
      member do
        patch :cancel
        get :ics
      end
    end
  end

  # Applicant area.
  namespace :applicant do
    resource :dashboard, only: [:show], controller: "dashboards"
    resources :applications, only: [:index, :create] do
      member do
        patch :withdraw
        get :onboarding
      end
      resources :onboarding_documents, only: [:create, :destroy]
    end
    resources :interviews, only: [:index] do
      member { get :ics }
    end
    resources :people, only: [:index]
    patch "discovery", to: "people#toggle", as: :toggle_discovery
    resources :groups, only: [:index, :create] do
      member { post :join }
    end
  end

  # Public landing page.
  root "pages#home"
end
