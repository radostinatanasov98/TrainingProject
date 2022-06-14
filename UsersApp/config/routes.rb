Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines testing routes
  get "home/index", to: "home#index"
  get "home/test", to: "home#test"
  get 'test/tokens', to: 'test#tokens'

  # Defines patients routes
  get 'patients/profile', to: 'patients#profile'
  get 'patients', to: 'patients#all'

  # Defines doctor routes
  get 'doctors/create_examination', to: 'doctors#create_examination'
  post 'doctors/post_examination', to: 'doctors#post_examination'
  
  # Defines user routes
  get 'users/log_in', to: 'users#log_in'
  get 'profile', to: 'users#profile'

  # Defines error route
  get 'error', to: 'application#show_error'

  # Defines root route
  root 'users#log_in'
end
