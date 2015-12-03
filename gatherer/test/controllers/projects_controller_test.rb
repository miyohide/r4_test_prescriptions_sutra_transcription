require "test_helper"

class ProjectsControllerTest < ActiveSupport::TestCase
  test "the project method creates a project" do
    post :create, project: {name: "Runway", tasks: "start something:2"}
    assert_redirected_to projects_path
    assert_equal "Runway", assigns[:action].project.name
  end

  test "the index method displays all projects correctly" do
    on_schedule = Project.create!(due_date: 1.year.from_now,
        name: "On Schedule",
        tasks: [Task.create!(completed_at: 1.day.ago, size: 1)])
    behind_schedule = Project.create!(due_date: 1.day.from_now,
        name: "Behind Schedule",
        tasks: [Task.create!(size: 1)])
    get :index
    assert_select("#project_#{on_schedule.id} .on_schedule")
    assert_select("#project_#{behind_schedule.id} .behind_schedule")
  end

  test "routing" do
    assert_routing "/projects", controller: "projects", action: "index"
    assert_routing({path: "/projects", method: "post"},
        controller: "projects", action: "create")
    assert_routing "/projects/new", controller: "projects", action: "new"
    assert_routing "/projects/1", controller: "projects",
        action: "show", id: "1"
    assert_routing "/projects/1/edit", controller: "projects",
        action: "edit", id: "1"
    assert_routing({path: "/projects/1", method: "patch"},
        controller: "projects", action: "update", id: "1")
    assert_routing({path: "/projects/1", method: "delete"},
        controller: "projects", action: "destroy", id: "1")
  end
end
