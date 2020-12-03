system 'cls'

require 'simplecov'
require 'minitest/autorun'
require 'minitest/reporters'
require 'date'
Minitest::Reporters.use!
SimpleCov.start

require_relative '../lib/todolist'

class TodoTest < Minitest::Test
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

  def test_no_due_date
    assert_nil(@todo1.due_date)
  end

  def test_no_due_date
    due_date = Date.today + 3
    @todo2.due_date = due_date
    assert_equal(due_date, @todo2.due_date)
  end

  def test_to_a
    assert_equal(@todos, @list.to_a)
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
    assert_equal(@todo1, @list.shift)
    assert_equal([@todo2, @todo3], @list.to_a)
  end

  def test_pop
    assert_equal(@todo3, @list.pop)
    assert_equal([@todo1, @todo2], @list.to_a)
  end

  def test_done_question
    assert_equal(false, @list.done?)
  end

  def test_add_raise_error
    assert_raises(TypeError) { @list << "Buy lettuce" }
    assert_raises(TypeError) { @list << 312 }
    assert_raises(TypeError) { @list << [1, 2, 3, 4] }
    assert_raises(TypeError) { @list << {a: 3} }
  end

  def test_shovel
    todo4 = Todo.new("Floss cat's teeth")
    @list << todo4
    @todos << todo4

    assert_equal(@todos, @list.to_a)
  end

  def test_add_alias
    todo4 = Todo.new("Floss cat's teeth")
    @list.add todo4
    todos = @todos << todo4

    assert_equal(todos, @list.to_a)
  end

  def test_item_at
    assert_equal(@todo1, @list.item_at(0))
    assert_equal(@todo2, @list.item_at(1))
    assert_raises(IndexError) { @list.item_at(20) }
  end

  def test_mark_done_at
    assert_raises(IndexError) { @list.mark_done_at(20) }
    
    @list.mark_done_at(0)

    assert_equal(true, @todo1.done?)
    assert_equal(false, @todo2.done?)
    assert_equal(false, @todo3.done?)
  end

  def test_mark_undone_at
    assert_raises(IndexError) { @list.mark_undone_at(20) }

    @todo1.done!
    @todo2.done!
    @todo3.done!

    @list.mark_undone_at(1)

    assert_equal(true, @todo1.done?)
    assert_equal(false, @todo2.done?)
    assert_equal(true, @todo3.done?)
  end

  def test_done_bang
    @list.done!

    assert_equal(true, @todo1.done?)
    assert_equal(true, @todo2.done?)
    assert_equal(true, @todo3.done?)
  end

  def test_remove_at
    assert_raises(IndexError) { @list.remove_at(20) }
    assert_equal(@todo1, @list.remove_at(0))
    assert_equal([@todo2, @todo3], @list.to_a)
  end

  def test_to_s_no_tasks_done
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT
  
    assert_equal(output, @list.to_s)
  end

  def test_to_s_one_task_done
    @list.mark_done_at(0)

    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT
  
    assert_equal(output, @list.to_s)
  end

  def test_s_all_tasks_done
    @list.done!

    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    OUTPUT
  
    assert_equal(output, @list.to_s)
  end

  def test_each
    test = []
    @list.each { |todo| test << todo }
    assert_equal(@todos, test)
  end

  def test_each_returns_original_list
    assert_equal(@list, @list.each { nil })
  end

  def test_select
    @list.mark_done_at(0)
    selection = @list.select { |todo| !todo.done? }
    assert_equal([@todo2, @todo3], selection.to_a)
  end

  def test_select_returns_new_list
    selection = @list.select { |todo| todo }
    refute_equal(@list, selection)
  end
  
  def test_find_by_title
    title = "Clean room"
    search_result = @list.select { |todo| todo.title == title }.first
    assert_equal(search_result, @list.find_by_title(title))
  end

  def test_all_done_select
    @list.mark_done_at(1)
    assert_equal(@todo2, @list.all_done.first)
  end

  def test_all_not_done_select
    @list.mark_done_at(0)
    @list.mark_done_at(2)
    assert_equal(@todo2, @list.all_not_done.first)
  end

  def test_mark_done
    title = "Clean room"
    @list.mark_done(title)
    assert_equal(true, @todo2.done?)
  end

  def test_mark_all_done
    completed_list = @list.clone.done!
    assert_equal(completed_list, @list.mark_all_done.to_a)
  end

  def test_mark_all_undone
    completed_list = @list.clone.undone!
    assert_equal(completed_list, @list.mark_all_undone.to_a)
  end
end

