require 'rails_helper'

RSpec.describe User, type: :model do
  RSpec::Matchers.define :be_able_to_see do |*projects|
    match do |user|
      expect(user.visible_projects).to eq(projects)
      projects.all? { |p| expect(user.can_view?(p)).to be_truthy }
      (all_projects - projects).all? { |p| expect(user.can_view?(p)).to be_falsy }
    end
  end

  describe "visibility" do
    let(:user) { User.create!(email: "user@example.com", password: "password") }
    let(:project_1) { Project.create!(name: "Project 1") }
    let(:project_2) { Project.create!(name: "Project 2") }
    let(:all_projects) { [project_1, project_2] }

    before(:example) do
      Project.delete_all
    end

    it "a user can see their projects" do
      user.projects << project_1
      expect(user).to be_able_to_see(project_1)
    end

    it "an admin can see all projects" do
      user.admin = true
      expect(user).to be_able_to_see(project_1, project_2)
    end

    it "a user can see public projects" do
      user.projects << project_1
      project_2.update_attributes(public: true)
      expect(user).to be_able_to_see(project_1, project_2)
    end

    it "no dupes in project list" do
      user.projects << project_1
      project_1.update_attributes(public: true)
      expect(user).to be_able_to_see(project_1)
    end
  end

  it "cannot view a project it is not a part of" do
    user = User.new
    project = Project.new
    expect(user.can_view?(project)).to be_falsy
  end

  it "can view a project it is a part of" do
    user = User.create!(email: "user@example.com", password: "password")
    project = Project.create!(name: "Project Gutenberg")
    user.roles.create(project: project)
    expect(user.can_view?(project)).to be_truthy
  end

  describe "public roles" do
    let(:user) { User.new }
    let(:project) { Project.new }

    it "allows an admin to view a project" do
      user.admin = true
      expect(user.can_view?(project)).to be_truthy
    end

    it "allows a public project to be seen by anyone" do
      project.public = true
      expect(user.can_view?(project)).to be_truthy
    end
  end

  describe "visible project listing" do
    let(:user) { User.create!(email: "user@example.com", password: "password") }
    let!(:project_1) { Project.create!(name: "Project 1") }
    let!(:project_2) { Project.create!(name: "Project 2") }

    before(:context) do
      Project.delete_all
    end

    it "allows a user to see their projects" do
      user.projects << project_1
      expect(user.visible_projects).to eq([project_1])
    end

    it "allows an admin to see all projects" do
      user.admin = true
      expect(user.visible_projects).to eq([project_1, project_2])
    end

    it "allows a user to see public projects" do
      user.projects << project_1
      project_2.update_attributes(public: true)
      expect(user.visible_projects).to eq([project_1, project_2])
    end

    it "has no dupes in project list" do
      user.projects << project_1
      project_1.update_attributes(public: true)
      expect(user.visible_projects).to eq([project_1])
    end
  end
end
