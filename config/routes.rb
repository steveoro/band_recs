BandRecs::Application.routes.draw do

  netzke

  scope "band_recs" do
    scope "(:locale)", :locale => /en|it/ do

      resources :authors do
        get 'index'
      end

      resources :bands do
        get 'index'
      end

      resources :musicians do
        get 'index'
      end

      resources :recordings do
        get 'index'
        # The following will recognize routes such as "/recordings/:id/manage"      
        member do
          get 'manage'
        end
      end

      resources :songs do
        get 'index'
      end
  
      resources :tags do
        get 'index'
      end

      resources :users do
        get 'index'
      end

      resources :app_parameters do
        get 'index'
      end

      # [Steve, 201201] The following named routes are created as convenient shortcuts used by the menu rendering
      match "(index)",            :controller => 'welcome',   :action => 'index',       :as => :index
      match "about",              :controller => 'welcome',   :action => 'about',       :as => :about
      match "contact_us",         :controller => 'welcome',   :action => 'contact_us',  :as => :contact_us
      match "whos_online",        :controller => 'welcome',   :action => 'whos_online', :as => :whos_online
      match "wip",                :controller => 'welcome',   :action => 'wip',         :as => :wip
      match "edit_current_user",  :controller => 'welcome',   :action => 'edit_current_user', :as => :edit_current_user

      match "login",              :controller => 'login',     :action => 'login',       :as => :login
      match "logout",             :controller => 'login',     :action => 'logout',      :as => :logout

      match "kill_session/:id",   :controller => 'users',     :action => 'kill_session',      :as => :kill_session
      match "upload",             :controller => 'upload',    :action => 'index',             :as => :upload
      match "upload/file_upload", :controller => 'upload',    :action => 'file_upload'
      match "upload/kill_file",   :controller => 'upload',    :action => 'kill_file'
      match "manage_files",       :controller => 'upload',    :action => 'manage_files',      :as => :manage_files
    end
  end


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
