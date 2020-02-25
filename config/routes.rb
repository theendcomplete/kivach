Rails.application.routes.draw do
  default_url_options host: Rails.application.config.domain
  post '/graphql', to: 'graphql#execute'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'application#root'
  get '/404', to: 'application#handle_error_404'
  get '/500', to: 'application#handle_error_500'
  get '/schema', to: 'application#schema'
end
