Rails.application.routes.draw do
  scope "api" do
    post "account", to: "account#create"
    put "account", to: "account#update"
    delete "account", to: "account#destroy"

    resources :users
  end
end
