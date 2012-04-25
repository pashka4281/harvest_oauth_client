require "spec_helper"

describe "resource -- project" do
  before(:each) do
    @code = "RTsDXvNZN+eSfmw73M8qOBxbRJh9792bXevvj7KQ8nd3oSnVdFvYRZIAQtldPzVDk6pG5eQZEiIYpZVOYU9/7g=="
    @harvest = HarvestOauthClient.create(@code, "paulsercomp")
  end


  it "should list all projects" do
    projects = @harvest.project.all
    projects.class.should == Array
  end

  context 'actions' do
    before do
      @projects = @harvest.project.all

      proj_params = {
        :name       => "Rspec test project #{rand(2**128).to_s(16)}",
        :active     => true,
        :client_id  => 983566
      }
      project_resp = @harvest.project.create(proj_params)
      @new_proj_id = project_resp.headers['Location'].gsub(/\D/, '').try(:to_i)
    end

    it 'should show particular project' do
      project = @harvest.project.find(@new_proj_id)
      project.class.should == HarvestOauthClient::Resources::Project
    end

    it 'should update particular project' do
      project = @harvest.project.find(@new_proj_id)
      project.name = "Renamed test project!!"
      result = project.save
      result.should be_true
    end

  end

end