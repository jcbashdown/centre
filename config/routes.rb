Centre::Application.routes.draw do

  resources :nodes
  resources :globals
  resources :links
  match '/nodes/:id/add_or_edit_link' => 'nodes#add_or_edit_link', :as => :add_or_edit_link

  root :to => "nodes#index"

  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}
  resources :users, :only => :show
end

