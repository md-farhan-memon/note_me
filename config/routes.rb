Rails.application.routes.draw do
  root to: 'notes#home'
  devise_for :users

  resources :notes, except: [:index] do
    collection do
      get :drafted
      get :shared
      get :shared_with_me
    end
    member do
      post :share
      delete :remove_access
    end
  end
end
