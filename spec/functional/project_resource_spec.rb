require "spec_helper"

describe "resource -- project" do
  before(:each) do
    @harvest = HarvestOauthClient.create(get_access_token(), "paulsercomp")
  end


  it "should list all projects" do
    projects = @harvest.project.all
    projects.class.should == Array
  end

  context 'actions' do
    before do
      @projects = @harvest.project.all

      proj_params = {
        :name       => "Rspec test project #{random_hash(128)}",
        :active     => true,
        :client_id  => 983566
      }
      @new_proj = @harvest.project.create(proj_params)
    end

    after do
      @new_proj.delete
    end

    it 'should show particular project' do
      project = @harvest.project.find(@new_proj.id)
      project.class.should == HarvestOauthClient::Resources::Project
    end

    it 'should update particular project' do
      project = @harvest.project.find(@new_proj.id)
      project.name = "Renamed test project!! #{random_hash(128)}"
      result = project.save
      result.should be_true
    end

    it 'should delete particular project' do
      proj_params = {
        :name       => "Rspec project for delete #{random_hash(128)}",
        :active     => true,
        :client_id  => 983566
      }
      proj = @harvest.project.create(proj_params)
      result = proj.delete
      result.should be_true
    end

  end

end