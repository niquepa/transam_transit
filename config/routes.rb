Rails.application.routes.draw do

  resources :rule_sets, :only => [] do
    resources :tam_policies do
      collection do
        post 'search'
        get 'tam_groups'
        get 'tam_metrics'
        get 'get_tam_groups'
      end

      resources :tam_groups do
        member do
          get 'fire_workflow_event'
          get 'distribute'
        end

        resources :tam_performance_metrics
      end
    end
  end

  resources :inventory, :only => [], :controller => 'assets' do
    resources :facility_rollup_wizard, controller: 'assets/facility_rollup_wizard'
  end

end
