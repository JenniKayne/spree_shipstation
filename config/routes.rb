Spree::Core::Engine.routes.draw do
  get  '/shipstation/shipnotify'
  post '/shipstation/shipnotify'
end

Spree::Core::Engine.add_routes do
  namespace :admin do
    patch 'orders/:id/shipstation_export', to: 'orders#shipstation_export', as: 'shipstation_export'
  end
end
