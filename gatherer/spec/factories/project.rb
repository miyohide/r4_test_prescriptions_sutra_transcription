FactoryGirl.define do
  factory :project do
    name "Project Runway"
    # ここでは波括弧が必要。ない場合、`-': expected numeric (TypeError)
    # とでてエラーとなる（rails console実行時）
    due_date { Date.today - rand(50) }
  end

  factory :big_project, class: Project do
    # P102の記載では「name: "Big Project"」だけどそれだとSyntax Errorとなる
    name "Big Project"
  end
end
