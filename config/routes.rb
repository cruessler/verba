Verba::Application.routes.draw do
  devise_for :users

  root 'learnables#overview'
  
  resources :ratings, only: [ :update ] do
    collection do
      get 'review'
    end
  end

  resources :words
  resources :phrases
end
