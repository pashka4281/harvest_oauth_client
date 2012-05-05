require "spec_helper"

describe "client -- project" do
  before(:each) do
    @harvest = HarvestOauthClient.create(get_access_token(), "paulsercomp")
  end


  it "should list all clients" do
    projects = @harvest.client.all
    projects.class.should == Array
  end

  context 'actions' do
    before do
      @clients = @harvest.client.all

      cl_params = {
        :name       => "Rspec test client #{random_hash(128)}",
        :active     => true
      }
      @new_client = @harvest.client.create(cl_params)
    end

    after do
      @new_client.delete
    end

    it 'should show particular project' do
      project = @harvest.client.find(@new_client.id)
      project.class.should == HarvestOauthClient::Resources::Client
    end

    it 'should update particular project' do
      project = @harvest.client.find(@new_client.id)
      project.name = "Renamed test project!! #{random_hash(128)}"
      result = project.save
      result.should be_true
    end

    it 'should delete particular project' do
      cl_params = {
        :name       => "Rspec client for delete #{random_hash(128)}",
        :active     => true
      }
      cl = @harvest.client.create(cl_params)
      result = cl.delete
      result.should be_true
    end

  end

end