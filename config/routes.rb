Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resource :classification_event, only: [:create, :update]
  resource :comment, only: [:create, :update]
  

  post '/counts/classifications', action: :query, controller: 'classification_count'
end
