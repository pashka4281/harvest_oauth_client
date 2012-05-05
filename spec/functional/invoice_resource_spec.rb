require "spec_helper"

describe "invoice -- project" do
  before(:each) do
    @harvest = HarvestOauthClient.create(get_access_token(), "paulsercomp")
  end


  it "should list all invoices" do
    invoices = @harvest.invoice.all
    invoices.class.should == Array
  end

  context 'actions' do
    before do
      @invoices = @harvest.invoice.all

      inv_params = {
        :name       => "Rspec test project #{random_hash(128)}",
        :active     => true,
        :client_id  => 983566
      }
      @new_invoice = @harvest.invoice.create(inv_params)
    end

    after do
      @new_invoice.delete
    end

    it 'should show particular invoice' do
      invoice = @harvest.invoice.find(@new_invoice.id)
      invoice.class.should == HarvestOauthClient::Resources::Invoice
    end

    it 'should update particular invoice' do
      invoice = @harvest.invoice.find(@new_invoice.id)
      invoice.name = "Renamed test invoice!! #{random_hash(128)}"
      result = invoice.save
      result.should be_true
    end

    it 'should delete particular invoice' do
      inv_params = {
        :name       => "Rspec invoice for delete #{random_hash(128)}",
        :active     => true,
        :client_id  => 983566
      }
      inv = @harvest.invoice.create(inv_params)
      result = inv.delete
      result.should be_true
    end

  end

end