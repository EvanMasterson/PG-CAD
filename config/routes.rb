Rails.application.routes.draw do
  # resources :storages, :uploaded_files
  resources :storages do
    resources :uploaded_files do
      member do
        get :download_file
      end
    end
  end

  devise_for :users, path: 'user', controllers: {
      :registrations => "users/registrations" }

  root :to =>'pages#index'
  
  post 'share_file' => 'uploaded_files#share_file'
  get 'download_shared_file/:unique_url' => 'uploaded_files#download_shared_file'
  get '*path' => redirect('/')
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
