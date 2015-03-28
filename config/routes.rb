Rails.application.routes.draw do

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources 'instructors'
    end
  end

  root to: "application#root"

end
