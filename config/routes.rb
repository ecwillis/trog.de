TrogDe::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'main#index'

  get '/shorten', to: 'main#shorten', as: :shorten

  get '/debug', to: 'main#debug'

  # auth - CB
  get '/auth/:provider/callback', to: 'session#callback' ## Omniauth
  get 'logout', to: 'session#destroy', as: :logout
  
  get ':link_id', to: 'main#jump'
end
