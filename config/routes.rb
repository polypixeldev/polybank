Rails.application.routes.draw do
  resource :session do
    collection do
      post "demo"
    end
  end

  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "static_pages#index"

  scope :plaid, controller: :plaid, as: "plaid" do
    post "webhook"
    get "linked"
    post "generate_link_token"
  end

  resources :users, only: [ :new, :create ]

  resources :accounts, only: [ :show ] do
    collection do
      post "generate_demo"
    end
  end

  resources :plaid_items, only: [] do
    member do
      post "sync"
      post "refresh"
    end
  end

  resources :transactions, only: [ :index, :show, :update ] do
    collection do
      get "list"
      post "export"
    end

    member do
      get "edit_memo"
      get "edit_category"

      get "add_tag_modal"
      post "toggle_tag"
    end
  end

  resources :counterparties, only: [ :index, :show, :update ] do
    member do
      get "edit_name"
    end
  end

  resources :categories, only: [ :index, :show ]

  resources :tags, only: [ :index, :new, :create, :show, :edit, :update, :destroy ] do
    collection do
      get "new_modal"
    end
  end

  scope :stats, controller: :stats, as: :stats do
    get "/", action: :index
  end

  resources :comments, only: [ :create, :edit, :update, :destroy ]
end
