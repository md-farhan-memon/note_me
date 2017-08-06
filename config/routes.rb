Rails.application.routes.draw do
  devise_for :users
  root to: 'notes#drafted'

  resources :notes, except: [:index] do
    collection do
      get :drafted
      get :shared
    end
  end
end
