Verba::Application.routes.draw do
  devise_for :users

  root 'learnables#overview'
  
  resources :learnables, only: [] do
    collection do
      get 'learn'
    end
    
    member do
      patch 'rate'
    end
  end

  resources :words
  resources :phrases
end
