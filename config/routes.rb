Rails.application.routes.draw do
    devise_for :users
    root 'explorer#index'

    resource :explorer do
        get 'search' => 'explorer#index', as: 'search'
    end
end
