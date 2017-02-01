Rails.application.routes.draw do
  devise_for :users
    root 'explorer#index'
end
