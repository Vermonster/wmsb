Wmsb::Application.routes.draw do
  root :to => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  resources :buses, only: :index
end
