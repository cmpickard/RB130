# This class represents a todo item and its associated
# data: name and description. There's also a "done"
# flag to show whether this todo item is done.

class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done

  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s
    "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
  end

  def ==(otherTodo)
    title == otherTodo.title &&
      description == otherTodo.description &&
      done == otherTodo.done
  end
end


# This class represents a collection of Todo objects.
# You can perform typical collection-oriented actions
# on a TodoList object, including iteration and selection.

class TodoList
  attr_accessor :title

  def initialize(title)
    @title = title
    @todos = []
  end

  def add(todo)
    raise TypeError, "only Todo objects!" unless todo.class == Todo
    todos << todo
  end

  alias_method :<<, :add

  def size
    todos.size
  end

  def first
    todos[0]
  end

  def last
    todos[-1]
  end

  def to_a
    todos.clone
  end

  def done?
    todos.all? { |todo| todo.done? }
  end

  def item_at(idx)
    todos.fetch(idx)
  end

  def mark_done_at(idx)
    item_at(idx).done!
  end

  def mark_undone_at(idx)
    item_at(idx).undone!
  end

  def done!
    todos.each { |todo| todo.done! }
  end

  def shift
    todos.shift
  end

  def pop
    todos.pop
  end

  def remove_at(idx)
    element = item_at(idx)
    todos.delete_at(idx)
    element
  end

  def to_s
    str = "---- #{title} -----"
    todos.each { |todo| str << "\n#{todo}"}
    str
  end

  def each 
    counter = 0
    while counter < todos.size
      yield(item_at(counter))
      counter += 1
    end
    self
  end

  def select
    selected_todos = TodoList.new(title)
    each do |todo|
      selected_todos << todo if yield(todo)
    end
    selected_todos
  end

  def reject
    rejected_todos = TodoList.new(title)
    each do |todo|
      rejected_todos << todo unless yield(todo)
    end
    rejected_todos
  end

  def find_by_title(str)
    each { |todo| return todo if todo.title == str }
    nil
  end

  def all_done
    select { |todo| todo.done? }
  end

  def all_not_done
    reject { |todo| todo.done? }
  end

  def mark_done(str)
    each { |todo| todo.done! if todo.title == str }
  end

  def mark_all_done
    each { |todo| todo.done! }
  end

  def mark_all_undone
    each { |todo| todo.undone! }
  end

  private

  attr_reader :todos
end


# Implement the below methods.
# Hint: use either TodoList#each or TodoList#select for the implementation.

# find_by_title	
#   takes a string as argument, and returns the first Todo object that matches the argument. Return nil if no todo is found.
# all_done	
#   returns new TodoList object containing only the done items
# all_not_done	
#   returns new TodoList object containing only the not done items
# mark_done	
#   takes a string as argument, and marks the first Todo object that matches the argument as done.
# mark_all_done	
#   mark every todo as done
# mark_all_undone	
#   mark every todo as not done