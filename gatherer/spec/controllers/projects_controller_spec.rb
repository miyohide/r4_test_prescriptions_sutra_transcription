require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  before(:example) do
    sign_in User.create!(email: "rspc@example.com", password: "password")
  end

  describe "POST create" do
    it "creates a project" do
      post :create, project: {name: "Runway", tasks: "Start something:2"}
      expect(response).to redirect_to(projects_path)
      expect(assigns(:action).project.name).to eq("Runway")
    end

    it "goes back to the form on failure" do
      post :create, project: {name: "", tasks: ""}
      expect(response).to render_template(:new)
      expect(assigns(:project)).to be_present
    end
  end

  it "fails create gracefully" do
    action_stub = double(create: false, project: Project.new)
    # CreatesProjectはapp/actions/creates_project.rbにて定義
    # createメソッド内でProjectも作るので、projectにも対応できるようにしている
    expect(CreatesProject).to receive(:new).and_return(action_stub)
    post :create, project: {name: "Project Runway"}
    expect(response).to render_template(:new)
  end

  it "fails update gracefully" do
    sample = Project.create!(name: "Test Project")
    expect(sample).to receive(:update_attributes).and_return(false)
    allow(Project).to receive(:find).and_return(sample)
    patch :update, id: sample.id, project: {name: "Fred"}
    expect(response).to render_template(:edit)
  end

  it "creates a project (mock version)" do
    fake_action = instance_double(CreatesProject, create: true)
    expect(CreatesProject).to receive(:new)
      .with(name: "Runway", task_string: "start something:2")
      .and_return(fake_action)
    post :create, project: {name: "Runway", tasks: "start something:2"}
    expect(response).to redirect_to(projects_path)
    expect(assigns(:action)).not_to be_nil
  end

  it "does not allow user to make a project public if it is not theirs" do
    sample = Project.create!(name: "Test Project", public: false)
    patch :update, id: sample.id, project: {public: true}
    expect(sample.reload.public).to be_falsy
  end

  describe "GET show" do
    let(:project) { Project.create(name: "Project Runway")}

    it "allows a user who is part of the project to see the project" do
      controller.current_user.stub(can_view?: true)
      get :show, id: project.id
      expect(response).to render_template(:show)
    end

    it "does not allow a user who is not part of the project to see the project" do
      controller.current_user.stub(can_view?: false)
      get :show, id: project.id
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "GET index" do
    it "displays all projects correctly" do
      user = User.new
      project = Project.new(name: "Project Greenlight")
      allow(controller).to receive(:current_user) { user }
      allow(user).to receive(:visible_projects) { [project] }

      get :index
      assert_equal assigns[:projects].map(&:__getobj__), [project]
    end
  end
end
