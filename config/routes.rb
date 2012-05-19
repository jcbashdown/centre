Centre::Application.routes.draw do

  resources :nodes, :except => [:new, :edit]
  resources :globals
  resources :links
  resources :arguments, :only => :show
  match '/nodes/:id/add_or_edit_link' => 'nodes#add_or_edit_link', :as => :add_or_edit_link

  root :to => "nodes#index"

  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}
  resources :users, :only => :show
end

