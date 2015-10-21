FactoryGirl.define do
  factory :project do
    name "Project Runway"
    due_date Date.parse("2014-01-12")
  end

  factory :big_project, class: Project do
    # P102の記載では「name: "Big Project"」だけどそれだとSyntax Errorとなる
    name "Big Project"
  end
end
