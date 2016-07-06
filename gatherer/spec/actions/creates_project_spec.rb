require "rails_helper"

describe CreatesProject do
  it "creates a project given a name" do
    creator = CreatesProject.new(name: "Project Runway")
    creator.build
    expect(creator.project.name).to eq("Project Runway")
  end

  it "adds users to the project" do
    user = User.new
    creator = CreatesProject.new(name: "Project Runway", users: [user])
    creator.build
    expect(creator.project.users).to eq([user])
  end

  describe "task string parsing" do
    # task_stringは各テストの前にletで指定してテストの柔軟性を確保する
    # letは必要が無い限り呼び出されないため、宣言部分では生成されていない。
    # このため、task_stringをテスト直前に設定することが可能となる。
    let(:creator) { CreatesProject.new(name: "Test", task_string: task_string) }
    let(:tasks) { creator.convert_string_to_tasks }

    describe "with an empty string" do
      let(:task_string) { "" }
      specify { expect(tasks.size).to eq(0) }
    end

    describe "with a single string" do
      let(:task_string) { "Start things" }
      specify { expect(tasks.size).to eq(1) }
      specify {expect(tasks.map(&:title)).to eq(["Start things"]) }
      specify {expect(tasks.map(&:size)).to eq([1]) }
    end

    describe "with multiple tasks" do
      let(:task_string) { "Start things:3\nEnd things:2"}
      it "handles multiple tasks" do
        expect(tasks).to match([
          an_object_having_attributes(title: "Start things", size: 3),
          an_object_having_attributes(title: "End things", size: 2)
          ])
      end
    end

    describe "attaches tasks to the project" do
      let(:task_string) { "Start things:3\nEnd things:2" }
      it "saves the project and tasks" do
        creator.create
        expect(creator.project.tasks.size).to eq(2)
        expect(creator.project).not_to be_a_new_record
      end
    end
  end
end
