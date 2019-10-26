Rails.application.routes.draw do
  devise_for :users, path: 'user'
  
  root :to =>'pages#index'
  
  get '*path' => redirect('/')
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
