FactoryGirl.define do
  factory :project do
    name "Project Runway"
    # ここでは波括弧が必要。ない場合、`-': expected numeric (TypeError)
    # とでてエラーとなる（rails console実行時）
    due_date { Date.today - rand(50) }
    # これも波括弧が必要。ない場合、undefined method `downcase' for
    # #<FactoryGirl::Declaration::Implicit:0x007f84f3a1cc58> (NoMethodError)
    # と出た。（rails console実行時 ）
    # なお、slugというカラムはないため、buildした時点で落ちる
    # slug "#{name.downcase.gsub(" ", "_")}"
  end

  factory :big_project, class: Project do
    # P102の記載では「name: "Big Project"」だけどそれだとSyntax Errorとなる
    name "Big Project"
  end
end
