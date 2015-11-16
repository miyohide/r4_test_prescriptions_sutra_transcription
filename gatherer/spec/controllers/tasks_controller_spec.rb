require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  before(:example) do
    ActionMailer::Base.deliveries.clear
  end

  describe "PATCH update" do
    let(:task) { Task.create!(title: "Write section on testing mailers", size: 2) }
    it "does not send an email if a task is not completed" do
      patch :update, id: task.id, task: {size: 3}
      expect(ActionMailer::Base.deliveries.size).to eq(0)
    end
  end

end
