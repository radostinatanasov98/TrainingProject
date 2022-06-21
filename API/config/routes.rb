Rails.application.routes.draw do
  resources :roles

  use_doorkeeper do
    controllers tokens: 'tokens'
    skip_controllers :authorizations, :applications, :atuhorized_applications
  end

  devise_for :users
  delete '/api/sign_out', to: 'tokens#sign_out'

  namespace :api do
    # Defines routes for authorization
    post 'users/create', to: 'users#create'
    get 'users/:id', to: 'users#get_user'

    # Defines routes for tokens
    get 'tokens', to: 'tokens#index'
    
    # Defines routes for users
    get 'get_patients', to: 'users#patients'

    # Defines routes for drugs
    get 'get_drugs', to: 'drugs#get_all'

    # Defines routes for examinations
    post 'examinations/create', to: 'examinations#create'
    get 'examinations/:id', to: 'examinations#get_by_id'
  end

  devise_scope :user do
    get 'users/sign_out' => "devise/sessions#destroy"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
