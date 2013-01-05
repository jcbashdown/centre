Centre::Application.routes.draw do

  resources :nodes, :except => [:new, :edit]
  resources :questions
  resources :links
  resources :user_arguments, :only => [:show, :index]
  resources :question_arguments, :only => [:show, :index]
  resources :arguments, :only => [:show, :index]

  root :to => "homepage#index"

  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}
end

