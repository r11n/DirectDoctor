namespace :admin do
  resources :dashboard, only: %i[index]
  scope module: 'blog' do
    resources :topics
    resources :tips
    resources :tags
  end
  resources :users
  resources :media_storages, only: %i[create destroy]
  resources :page_redirects
  resources :specialities
end
