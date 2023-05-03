# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post 'kinesis', to: 'kinesis#create'

  post '/counts/classifications', action: :query, controller: 'classification_count'
end
