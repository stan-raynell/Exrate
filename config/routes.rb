# frozen_string_literal: true

Rails.application.routes.draw do
  root "rates#index"
  get "/admin", to: "rates#force"
  post "/admin", to: "rates#set"
  resources :rates
end
