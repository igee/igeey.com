require 'spec_helper'

describe TasksController do
  render_views  
  
  def mock_task(stubs={})
    @mock_task ||= mock_model(Task, stubs)
  end
     
  it "shoud response collection REST path" do
    get :index
    response.should be_success
  end

  it "shoud response member REST path" do
    Task.stub(:find).with("1").and_return(mock_task)
    task = mock_model(Task)
    get :show,:id => "1"
    response.should be_success
  end
end
