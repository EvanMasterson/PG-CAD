Rails.application.routes.draw do
  # resources :storages#, :uploaded_files
  resources :storages do
    resources :uploaded_files
  end
  devise_for :users, path: 'user'
  
  root :to =>'pages#index'
  
  get '/profile', to: 'pages#profile'
  get '*path' => redirect('/')
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
