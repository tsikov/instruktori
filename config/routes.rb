Rails.application.routes.draw do

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources 'instructors' do
        collection do
          get "cities"
          get "categories"
        end
      end
      resources 'results'
    end
  end

  get "/*path" => redirect("/?goto=%{path}")
  root to: "application#root"

end
