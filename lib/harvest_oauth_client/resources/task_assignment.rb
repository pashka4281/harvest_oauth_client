module HarvestOauthClient
  module Resources
    class TaskAssignment < HarvestOauthClient::Restful::Resource

      belongs_to(:project)

      has_attributes(:id, :project_id, :task_id, :billable, :deactivated, :budget, :hourly_rate, :updated_at, :created_at)


      def	self.create(project_id, params = {})
        raise ":name parameter is not set!" if params[:name].blank?
        resp = request(:post, "https://api.harvestapp.com/projects/#{project_id}/task_assignments/add_with_create_new_task", JSON('task' => params))
#        self.new(params.merge(:id => resp.headers['Location'].gsub(/\D/, '').try(:to_i)))
      end
      
    end
  end
end