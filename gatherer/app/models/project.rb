class Project < ActiveRecord::Base

  has_many :tasks

  def done?
    tasks.reject(&:complete?).empty?
  end

  def total_size
    tasks.sum(&:size)
  end

  def remaining_size
    tasks.reject(&:complete?).sum(&:size)
  end

  # 3週間前に完了したタスクのvelocityの合計を算出する
  def completed_velocity
    tasks.sum(&:points_toward_velocity)
  end

  # 3週間前に完了したタスクのvelocityの1日あたりの値を算出する
  def current_rate
    completed_velocity * 1.0 / Project.velocity_length_in_days
  end

  # 残りのタスクのサイズとcurrent_rateから残りの日付を算出する
  def projected_days_remaining
    remaining_size / current_rate
  end

  # オンスケであればtrue、遅延しているならfalseを返す
  def on_schedule?
    return false if projected_days_remaining.nan?
    (Date.today + projected_days_remaining) <= due_date
  end

  def self.velocity_length_in_days
    21
  end
end
