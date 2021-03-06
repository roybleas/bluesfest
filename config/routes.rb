Rails.application.routes.draw do


  get 'settime/:day/:hr/:min', to: 'testpages#settime', as: :settime
	get 'reset', to: 'testpages#reset'
  get 'showtime', to: 'testpages#showtime'

	delete 'favourites/clearall/', to: 'favourites#clearall', as: :favclearall
	resources :favourites, only: [:index, :destroy, :create]
  get 'favourites/add/:letter', 	to: 'favourites#add', as: :favadd
  get 'favourites/day/:dayindex', to: 'favourites#day', as: :favday
  get 'favourites/artist/:id', to: 'favourites#artist', as: :favartist
  patch 'favourites/performanceupdate/:id',  to: 'favourites#performanceupdate', as: :favperformupdate
  
	
	resources :performances, only: [:index, :update, :edit]
  get 'showbyday/:dayindex', to: 'performances#showbyday', as: :showbyday

  get 'stages/:id/:dayindex' => 'stages#show', as: :stage 
	resources :stages, only: [:index]
  resources :artists, only: [:show, :index]
  get 'artists/bypage/:letter', to: 'artists#bypage',  as: 'artistsbypage'
  

  root 'home_pages#home'
  get 'now'  			 => 'home_pages#now'
  get 'next' 			 => 'home_pages#next'
  
  get 'festivals/index'
	
	
  resources :users
  get    'signup' => 'users#new'
  get 	 'login'	=> 'sessions#new'
  post 	 'login'	=> 'sessions#create'
  delete 'logout'	=> 'sessions#destroy'
  get	   'users/reset/:id',  to: 'users#reset', as: :pwdreset
	
	get 'about' => 'static_pages#about'
	get 'help' => 'static_pages#help'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
