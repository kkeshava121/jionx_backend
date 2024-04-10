require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/stats"

  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  namespace :api do
    namespace :v2 do
      resources :agents do
        collection do
          post :verify_agent_by_pincode
          post :insert_or_update_modem
          post :insert_multiple_messages
          post :verify_modem
        end
      end
    end

    namespace :v1 do

      devise_for :users, controllers: {
        registrations: 'api/v1/registrations',
        sessions: 'api/v1/sessions'
      }

      resources :users, only: [:destroy] do
        collection do
          get 'pincode', to: 'users#generate_pincode'
          get :get_users_by_parent_id_and_role
          get :get_user_by_id
          post :verify_user_by_pincode
          post :update_user
          get :merchants_list
          post :assign_or_remove_merchant
          post :sign_out_user
          post :change_password
          get :dashboard_data
        end
      end

      # resources :agents do
      #   collection do
      #     post :verify_agent_by_pincode
      #     post :insert_or_update_modem
      #     post :insert_multiple_messages
      #   end
      # end

      resources :balance_manager, only: [:index] do
        collection do
          post :insert_balance
          post :get_balance_by_filter
          post :update_status
          post :update_multiple_status
          get :get_status_count
          get :todays_data
          get :daily_status_count
        end
      end

      resources :banks, only: [:index] do
        collection do
          get :get_all_banks
        end
      end

      resources :messages, only: [:index] do
        collection do
          post :get_messages_by_filter
          post :insert_multiple_messages
          get :todays_data
        end
      end

      resources :modems, only: [:index, :create] do
        collection do
          post :insert_or_update_modem
          get :get_all_modems
          post :delete_multi_modems
          post :update_modem_status
          post :get_modems_by_filter
          post :modem_activation
        end
        member do
          get :delete_modem
        end
      end

      resources :modem_settings, only: [:index] do
        collection do
          post :insert_or_update_modem_setting
          get :get_all_modem_settings
          post :delete_modem
        end
      end

    end
  end
end