DummyApp::Application.routes.draw do
  get '/rooms/:id',    to: 'rooms#show',    as: :room
  get '/articles/:id', to: 'articles#show', as: :article
end
