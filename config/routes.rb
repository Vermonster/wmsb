Wmsb::Application.routes.draw do
  root :to => 'site#index'
  post 'login' => 'sessions#create'
  resources :buses, only: :index
end
