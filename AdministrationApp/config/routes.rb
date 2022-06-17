Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  # Defines paths for creating a user
  get "users/create", to: "users#create"
  post "users/create", to: "users#new"
  get "users/update", to: "users#update"
  post "users/update", to: "users#put"
  get "users/all", to: "users#all"
  delete "users/delete", to: "users#destroy"
  get "users/show", to: "users#show"

  # Defines paths for drugs
  get "drugs/create", to: "drugs#create"
  post "drugs/create", to: "drugs#new"
  get "drugs/update", to: "drugs#update"
  post "drugs/update", to: "drugs#put"
  get "drugs/show", to: "drugs#show"
  get "drugs/all", to: "drugs#all"
  delete "drugs/delete", to: "drugs#destroy"

  devise_scope :user do
    authenticated :user do
      root 'devise/registrations#edit', as: :authenticated_root
    end
  
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
end
