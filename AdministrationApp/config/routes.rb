Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  # Defines paths for creating a user
  get "users/create", to: "users#create"
  post "users/create", to: "users#new"
  
  # Defines paths for editing a user
  get "users/update", to: "users#update"
  post "users/update", to: "users#put"

  # Defines paths for viewing all users
  get "users/all", to: "users#all"

  # Defines path for deleting users
  delete "users/delete", to: "users#destroy"

  # Defines paths for searching users
  get "users/show", to: "users#show"

  devise_scope :user do
    authenticated :user do
      root 'devise/registrations#edit', as: :authenticated_root
    end
  
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
end
