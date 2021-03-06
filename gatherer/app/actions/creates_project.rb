class CreatesProject
  attr_accessor :name, :task_string, :project, :users

  def initialize(name: "", task_string: "", users: [])
    @name = name
    @task_string = task_string
    @users = users
  end

  def build
    self.project = Project.new(name: name)
    project.tasks = convert_string_to_tasks
    project.users = users
    project
  end

  # 文字列を\nで分割してTaskの配列として返す
  # @return [Array] @task_string を\nで分割して生成したTaskの配列
  def convert_string_to_tasks
    task_string.split("\n").map do |task_string|
      title, size = task_string.split(":")
      size = 1 if (size.blank? || size.to_i.zero?)
      Task.new(title: title, size: size)
    end
  end

  def create
    build
    project.save
  end
end
