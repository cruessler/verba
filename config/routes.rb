Verba::Application.routes.draw do
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
