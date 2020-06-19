Rails.application.routes.draw do

  mount Tolk::Engine => '/translation_tool', :as => 'tolk'
  constraints(Subdomain::Brand) do
    devise_for :admin_users, ActiveAdmin::Devise.config
    
    devise_for :users, controllers: { sessions: "users/sessions", confirmations: 'users/confirmations', 
                                      :registrations => 'users/registrations', :passwords => 'users/passwords',
                                      :mailer => 'users/mailer' }
    ActiveAdmin.routes(self)
    
    devise_scope :user do
      get "shivshakti", to: "users/sessions#new", as: 'sign_in'
      get "sign_in_by_token/:token", to: "users/sessions#sign_in_by_token", as: 'sign_in_by_token'
      get "sign_out", to: "users/sessions#destroy"
      get "sign_up", to: "users/registrations#new"
      get "forgot_password", to: "users/passwords#new"
    end

    # users
    resources :user do
      collection do
        get 'user_edit_password/(:id)', to: "user#edit", as: 'user_edit_password'
        patch 'update_password', to: "user#update_password", as: 'update_password'
        get 'edit_profile', to: "user#edit_profile", as: "edit_profile"
        patch 'update_profile', to: "user#update_profile", as: 'update_profile'
        match 'update_old_password', to: "user#update_old_password", as: 'update_old_password', via: [:post, :patch]
      end
    end
    
    # executives
    resources :executives do
      collection do
        get 'desktop'
        get 'resources_and_variables'
        post "/search/user_filter" => "executives#user_filter", :as => :user_filter
        get 'next_users/:page', to: 'executives#next_users', as: 'next_users'
      end
    end

    # directors
    resources :staffs do
      collection do
        get 'desktop'
      end
    end

    # customers
    resources :customers do
      collection do
        post "/search/customer_filter" => "customers#customer_filter", :as => :customer_filter
        get 'next/:page', to: 'customers#next_customers', as: 'next'
      end
    end    

    # providers
    resources :providers do
      collection do
        post "/search/provider_filter" => "providers#provider_filter", :as => :provider_filter
        get 'next/:page', to: 'providers#next_providers', as: 'next'
      end
    end

    # balance_sheets
    resources :balance_sheets do
      collection do
        post "/search/balance_sheet_filter" => "balance_sheets#balance_sheet_filter", :as => :balance_sheet_filter
        get 'next/:page', to: 'balance_sheets#next_balance_sheets', as: 'next'
      end
    end 

    # customer_bills
    resources :customer_bills do
      collection do
        post "/search/customer_bill_filter" => "customer_bills#customer_bill_filter", :as => :customer_bill_filter
        get 'next/:page', to: 'customer_bills#next_customer_bills', as: 'next'
      end
    end

    # customer_bill_products
    resources :customer_bill_products do
      collection do
        post "/search/customer_bill_product_filter" => "customer_bill_products#customer_bill_product_filter", :as => :customer_bill_product_filter
        get 'next/:page', to: 'customer_bill_products#next_customer_bill_product', as: 'next'
      end
    end

    # customer_bill_payments
    resources :customer_bill_payments do
      collection do
        post "/search/customer_bill_payment_filter" => "customer_bill_payments#customer_bill_payment_filter", :as => :customer_bill_payment_filter
        get 'next/:page', to: 'customer_bill_payments#next_customer_bill_payment', as: 'next'
      end
    end    

    # stocks
    resources :stocks do
      collection do
        post "/search/stock_filter" => "stocks#stock_filter", :as => :stock_filter
        get 'next/:page', to: 'stocks#next_stocks', as: 'next_stocks'
      end
    end   

    # product_purchases
    resources :product_purchases do
      collection do
        post "/search/product_purchase_filter" => "product_purchases#product_purchase_filter", :as => :product_purchase_filter
        get 'next/:page', to: 'product_purchases#next_product_purchases', as: 'next'
      end
    end 

    # income_expenses
    resources :income_expenses do
      collection do
        post "/search/income_expense_filter" => "income_expenses#income_expenses_filter", :as => :income_expense_filter
        get 'next/:page', to: 'income_expenses#next_income_expenses', as: 'next'
      end
    end

    # emails
    resources :emails do
      collection do
        post '/order_email_for_user', to: 'emails#order_email_for_user', as: 'order_email_for_user'
        post '/send_feedback_email', to: 'emails#send_feedback_email', as: 'send_feedback_email'
        post '/:id/send_login_info_by_email', to: 'emails#send_login_info_by_email', as: 'send_login_info_by_email'
        post '/:id/send_invoice_to_accountant_via_email_form', to: 'emails#send_invoice_to_accountant_via_email', as: 'send_invoice_to_accountant_via_email'
        post '/:id/send_invoice_via_email_form', to: 'emails#send_invoice_via_email', as: 'send_invoice_via_email'
      end
    end

    # resources
    resources :resources do
        member do
          post 'save_media', to: 'resources#save_media'
          post 'delete_media', to: 'resources#delete_media'
          get 'download', :to => 'resources#download'
        end    
      end
    get '/resources/get_resource_holders', :to => 'resources#get_resource_holders', :as => 'resources_get_resource_holders'

    #settings - resource_variables, notification_values
    resources :settings, only: [] do
      collection do
        get ":type" => "settings#index", :as => :default
        put ":type" => "settings#update", :as => :update
        post "/soft/:action_type/:object_type/:object_id" => "settings#soft_delete", as: :soft_delete
        get '/more_options/:object_type/:object_id' => "settings#more_options", :as => :more_options
        get '/more_options/:object_type/:object_id/remove' => "settings#remove_user_data", :as => :remove_user_data
        match "/personal/edit" => "settings#my_settings", :as => :personal, via: [:get, :patch]
      end
    end

    #pdf
    resources :pdf, only: [] do
      member do
        # send PDF
        get 'send_pdf', to: 'pdf#send_pdf', as: 'send'
        get 'print_invoice', to: 'pdf#print_invoice', as: 'print_invoice'
        get 'reward_detail', to: 'pdf#reward_detail', as: 'reward_detail'
      end
    end
    
    root 'desktop#index'
  end
end
