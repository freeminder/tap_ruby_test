Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  devise_for :users
  root to: "application#index"
  match "*path", to: "application#not_found", via: :all
end
