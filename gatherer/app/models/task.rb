class Task
  attr_accessor :size, :completed

  # このinitializeの処理はActiveRecordで実装していたら不要なもの。
  # だが、P32に書かれているように今ここでActiveRecordの導入は適して
  # いないのでまだ実装しない。
  def initialize(options = {})
    @completed = options[:completed]
    @size = options[:size]
  end

  def mark_completed
    @completed = true
  end

  def complete?
    @completed
  end
end
