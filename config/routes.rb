Rails.application.routes.draw do
  root 'home#index'

  resources :integrations
  get '/integrations/lists/:service' => 'integrations#lists'
end
