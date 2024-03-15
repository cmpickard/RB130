require 'simplecov'
require 'minitest/autorun'
require "minitest/reporters"

SimpleCov.start
Minitest::Reporters.use!

require_relative 'to_do'

class TodoListTest < Minitest::Test

  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  def test_to_a
    list_arr = @list.to_a
    assert_equal(Array, list_arr.class)
    assert_equal(@todos, list_arr)
  end

  def test_size
    assert_equal(3, @list.size)
  end

  def test_first
    assert_equal(@todo1, @list.first)
  end

  def test_last
    assert_equal(@todo3, @list.last)
  end

  def test_shift
    first_todo = @list.shift
    new_list = TodoList.new("Today's Todos")
    new_list << @todo2 << @todo3
    assert_equal(@todo1, first_todo)
    assert_equal(new_list, @list)
  end

  def test_pop
    last_todo = @list.pop
    new_list = TodoList.new("Today's Todos")
    new_list << @todo1 << @todo2
    assert_equal(last_todo, @todo3)
    assert_equal(new_list, @list)
  end

  def test_done?
    assert_equal(false, @list.done?)
    @list.done!
    assert_equal(true, @list.done?)
    @list.mark_undone_at(1)
    assert_equal(false, @list.done?)
  end

  def test_item_at
    assert_equal(@todo1, @list.item_at(0))
    assert_raises(IndexError) { @list.item_at(100) }
  end

  def test_shovel
    @list << @todo1
    assert_equal([@todo1, @todo2, @todo3, @todo1], @list.to_a)
  end

  def test_add
    @list.add(@todo1)
    assert_equal([@todo1, @todo2, @todo3, @todo1], @list.to_a)
  end

  def test_type_error
    assert_raises(TypeError) { @list.add(1) }
  end

  def test_mark_done_at
    @list.mark_done_at(0)
    assert_raises(IndexError) { @list.mark_done_at(100)}
    assert_equal(@todo1.done?, @list.item_at(0).done?)
  end

  def test_mark_undone_at
    @list.done!
    @list.mark_undone_at(0)
    assert_raises(IndexError) { @list.mark_undone_at(100) }
    assert_equal(@todo1.done?, @list.item_at(0).done?)
  end

  def test_done!
    @list.done!
    assert_equal(@todo1.done?, @list.item_at(0).done?)
    assert_equal(@todo2.done?, @list.item_at(1).done?)
    assert_equal(@todo3.done?, @list.item_at(2).done?)
  end

  def test_remove_at
    removed = @list.remove_at(2)
    assert_raises(IndexError) { @list.remove_at(100) }
    assert_equal(@todo3, removed)
  end

  def test_to_s
    @list.mark_done_at(0)
    string = @list.to_s
    exp = <<~HEREDOC.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [ ] Clean room
    [ ] Go to gym
    HEREDOC
    assert_equal(exp, string)

    @list.done!
    string = @list.to_s
    exp = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    OUTPUT
    assert_equal(exp, string)
  end

  def test_each
    str = ''
    @list.each { |todo| str << todo.title }
    exp = "Buy milkClean roomGo to gym"
    assert_equal(exp, str)

    return_val = @list.each {}
    assert_equal(@list, return_val)
  end

  def test_select
    str = ''
    @list.select { |todo| str << todo.title }
    exp = "Buy milkClean roomGo to gym"
    assert_equal(exp, str)

    return_val = @list.select { |todo| todo.title == 'Buy milk'}
    exp = TodoList.new("Today's Todos")
    exp.add(@todo1)
    assert_equal(exp, return_val)
  end

  def test_find_by_title
    result = @list.find_by_title('Go to gym')
    assert_equal(@todo3, result)
  end

  def test_all_done
    @list.mark_done_at(0)
    @list.mark_done_at(1)
    assert_equal([@todo1, @todo2], @list.all_done.to_a)
  end

  def test_all_not_eon
    @list.mark_done_at(0)
    @list.mark_done_at(1)
    assert_equal([@todo3], @list.all_not_done.to_a)
  end

  def test_mark_done
    @list.mark_done('Buy milk')
    assert_equal([@todo1], @list.all_done.to_a)
  end

  def test_mark_all_done
    @list.mark_all_done
    assert_equal([@todo1, @todo2, @todo3], @list.all_done.to_a)
  end

  def test_mark_all_undone
    @list.mark_all_done
    @list.mark_all_undone
    assert_equal([], @list.all_done.to_a)
  end
end