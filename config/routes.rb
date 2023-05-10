# frozen_string_literal: true

Rails.application.routes.draw do
  root "rates#index"
  get "/admin", to: "rates#show"
  post "/admin", to: "rates#set_forced_rate"
end
