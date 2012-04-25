module HarvestOauthClient
  module Resources
    class User < HarvestOauthClient::Restful::Resource

      has_attributes(:first_timer, :created_at, :has_access_to_all_future_projects, :preferred_approval_screen,
                      :preferred_project_status_reports_screen, :wants_newsletter, :twitter_username,
                      :default_expense_category_id, :default_task_id, :default_time_project_id, :is_contractor,
                      :preferred_entry_method, :updated_at, :id, :timezone, :duplicate_timesheet_wants_notes,
                      :is_admin, :opensocial_identifier, :cache_version, :default_hourly_rate, :is_active,
                      :last_name, :wants_timesheet_duplication, :default_expense_project_id, :email_after_submit,
                      :telephone, :department, :identity_url, :email, :first_name)


      def self.base_path
        "/people"
      end

    end
  end
end