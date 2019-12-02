Rails.application.routes.draw do
  # resources :storages, :uploaded_files
  resources :storages do
    resources :uploaded_files do
      member do
        get :download_file
        get :download_shared_file
      end
    end
  end

  devise_for :users, path: 'user', controllers: {
      :registrations => "users/registrations" }

  root :to =>'pages#index'
  
  get '*path' => redirect('/')
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
