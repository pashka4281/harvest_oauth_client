module HarvestOauthClient
  module Resources
    class Project < HarvestOauthClient::Restful::Resource

      has_attributes(:name, :over_budget_notified_at, :billable, :created_at, :earliest_record_at,
                      :show_budget_to_all, :code, :cost_budget, :notify_when_over_budget, :updated_at,
                      :notes, :cost_budget_include_expenses, :fees, :highrise_deal_id, :latest_record_at,
                      :hourly_rate, :id, :estimate_by, :bill_by, :client_id, :hint_latest_record_at,
                      :active_user_assignments_count, :cache_version, :budget, :over_budget_notification_percentage,
                      :hint_earliest_record_at, :active, :active_task_assignments_count, :basecamp_id,
                      :budget_by, :estimate)

      def	self.create(params ={})
        raise ":client_id is required" if !params.has_key?(:client_id)
        super(params)
      end
	
    end
  end
end