YoutubeItRailsAppExample::Application.routes.draw do
  resources :searches do
  new do
    post :show
    get  :save_search
  end
  end

  root :to => "searches#index"
end
