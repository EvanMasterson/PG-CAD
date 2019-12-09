Rails.application.routes.draw do
  # resources :storages, :uploaded_files
  resources :storages do
    resources :uploaded_files do
      member do
        get :download_file
      end
    end
  end

  # due to the use of the custom regitration controller we had to define the new registration path for devise
  devise_for :users, path: 'user', controllers: {
      :registrations => "users/registrations" }

  root :to =>'pages#index'
  
  # share file with others 
  post 'share_file' => 'uploaded_files#share_file'
  # user clicks on the received URL with the uniquie_url in path and to search a file with the unique_url
  # endpoint to securley download files for not their owner.
  get 'download_shared_file/:unique_url' => 'uploaded_files#download_shared_file'
  get '*path' => redirect('/')
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
