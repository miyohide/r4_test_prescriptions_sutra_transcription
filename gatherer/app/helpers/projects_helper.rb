module ProjectsHelper
  def name_with_status(project)
    content_tag(:span, project.name, class: "on_schedule")
  end
end
