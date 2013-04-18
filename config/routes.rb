Wmsb::Application.routes.draw do
  root :to => 'site#index'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  resources :buses, only: :index
end
