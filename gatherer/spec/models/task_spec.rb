require "rails_helper"

RSpec.describe Task do
  it "can distinguish a completed task" do
    task = Task.new
    expect(task).not_to be_complete
    task.mark_completed
    expect(task).to be_complete
  end

  describe "velocity" do
    let(:task) { Task.new(size: 3) }

    it "does not count an incomplete task toward velocity" do
      expect(task).not_to be_part_of_velocity
      expect(task.points_toward_velocity).to eq(0)
    end

    it "does not count a long-ago task toward velocity" do
      task.mark_completed(6.months.ago)
      expect(task).not_to be_part_of_velocity
      expect(task.points_toward_velocity).to eq(0)
    end

    it "counts a 2 weeks and 6 days ago completed task toward velocity" do
      task.mark_completed(3.week.ago + 1.day)  # 3週間前 + 1日 = 2週間と6日前
      expect(task).to be_part_of_velocity
      expect(task.points_toward_velocity).to eq(3)
    end

    it "counts a 3 weeks ago completed task toward velocity" do
      task.mark_completed(3.week.ago)  # 3週間前
      expect(task).not_to be_part_of_velocity
      expect(task.points_toward_velocity).to eq(0)
    end

    it "counts a recently completed task toward velocity" do
      task.mark_completed(1.day.ago)
      expect(task).to be_part_of_velocity
      expect(task.points_toward_velocity).to eq(3)
    end
  end
end
