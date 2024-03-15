require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

require_relative 'to_do'

class TestTodo < Minitest::Test
  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @list = TodoList.new("Today's Todos")
  end

  def test_size
    @list.add(@todo1)
    assert_equal 1, @list.size
  end

  def test_first
    @list.add(@todo1)
    @list.add(@todo2)
    assert_equal @todo1, @list.first
  end

  def test_last
    @list.add(@todo1)
    @list.add(@todo2)
    assert_equal @todo2, @list.last
  end

  def test_shift
    @list.add(@todo1)
    @list.add(@todo2)
    assert_equal @todo1, @list.shift
    assert_equal @todo2, @list.first
    assert_equal 1, @list.size
  end

  def test_pop
    @list.add(@todo1)
    @list.add(@todo2)
    assert_equal @todo2, @list.pop
    assert_equal @todo1, @list.first
    assert_equal 1, @list.size
  end

  def test_done?
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
    refute @list.done?
    @list.done!
    assert @list.done?
  end

  def test_shovel
    @list << @todo1
    assert_equal @todo1, @list.first
  end

  def test_add
    @list << @todo1
    assert_equal @todo1, @list.first
  end

  def test_item_at
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
    assert_equal @todo1, @list.item_at(0)
    assert_raises(IndexError) { @list.item_at(1000) }
  end

  def test_mark_done_at
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
    @list.mark_done_at(0)
    assert @list.first.done?
    assert_raises(IndexError) { @list.mark_done_at(1000) }
  end

  def test_mark_undone_at
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
    @list.done!
    @list.mark_undone_at(0)
    refute @list.first.done?
    assert_raises(IndexError) { @list.mark_undone_at(1000) }
  end

  def test_done!
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
    @list.done!
    assert @list.done?
  end

  def test_remove_at
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
    @list.remove_at(1)
    assert_equal @todo3, @list.item_at(1)
    assert_raises(IndexError) { @list.remove_at(1000) }
  end

  def test_to_s
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
    @list.first.done!
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT
    assert_equal output, @list.to_s
    @list.done!
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    OUTPUT
    assert_equal output, @list.to_s
  end

  def test_to_a
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
    arr = @list.to_a
    assert_equal [@todo1, @todo2, @todo3], arr
  end

  def test_each
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
    assert_equal @list, @list.each { |todo| todo.done! }
    assert @list.done?
  end

  def test_select
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
    @list.last.done!
    assert_equal @todo3, @list.select { |todo| todo.done? }.first
  end

  def test_find_by_title
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
    assert_equal @todo1, @list.find_by_title('Buy milk')
  end

  def test_all_done
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
    @list.first.done!
    @list.last.done!
    done_list = TodoList.new("Today's Todos")
    done_list << @todo1 << @todo3
    assert_equal done_list, @list.all_done
  end

  def test_all_not_done
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
    @list.first.done!
    @list.last.done!
    undone_list = TodoList.new("Today's Todos")
    undone_list << @todo2
    assert_equal undone_list, @list.all_not_done
  end

  def test_mark_done
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
    @list.mark_done('Buy milk')
    assert @list.first.done?
  end

  def test_mark_all_done
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
    @list.mark_all_done
    assert @list.done?
  end

  def test_mark_all_undone
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
    @list.item_at(0).done!
    @list.item_at(1).done!
    @list.item_at(2).done!
    assert @list.done!
    @list.mark_all_undone
    refute @list.item_at(0).done?
    refute @list.item_at(1).done?
    refute @list.item_at(2).done?
  end

  def test_equal_equal
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
    second_list = TodoList.new("Today's Todos")
    second_list << @todo1 << @todo2 << @todo3
    assert @list == second_list
  end
end