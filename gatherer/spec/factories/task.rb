FactoryGirl.define do
  factory :task do
    title "To Something"
    size 3
    # associationは生成すると同時に関連するfactoryを生成する
    # このケースだと、まずprojectが作られて、その後にtaskが作られる
    project  # association
  end
end
