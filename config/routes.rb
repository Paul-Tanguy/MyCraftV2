Rails.application.routes.draw do
  root :to => redirect("/recipes")
  resources :recipes

  resources :core_material
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
