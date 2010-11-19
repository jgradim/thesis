require 'set'

#
class Accountability

  class Invalid; end;

  attr_accessor :parent, :child, :type
  
  def initialize(parent, child, type)
  
    throw Accountability::Invalid if not validates(parent, child, type)
  
    @parent = parent
    parent.add_child_accountability(self)
    @child = child
    child.add_parent_accountability(self)
    @type = type
  end
  
  def validates(parent, child, type)
    return false if parent == child
    return false if parent.ancestors_include(child, type)
    true
  end

end

#
class Party

  attr_accessor :parent_accountabilities, :child_accountabilities, :name

  def initialize(name)
    @parent_accountabilities = Set.new
    @child_accountabilities = Set.new
    @name = name
  end
  
  #
  def parents(type = nil)
    return @parent_accountabilities.map(&:parent) if type == nil
    return @parent_accountabilities.select{ |a| a.type ==  type }.map(&:parent)
  end
  
  def children(type = nil)
    return @child_accountabilities.map(&:child) if type == nil
    return @child_accountabilities.select{ |a| a.type ==  type }.map(&:child)
  end
  
  #
  def add_child_accountability(accountability)
    @child_accountabilities.add(accountability)
  end
  
  def add_parent_accountability(accountability)
    @parent_accountabilities.add(accountability)
  end
  
  #
  def ancestors_include(sample, type)
    parents(type).each do |p|
      return true if p == sample
      return true if p.ancestors_include(sample, type)
    end
    false
  end

end

# benchmarks
parties = []
accountabilities = []

puts "with 3 @parties per 9 @accountabilities:\n"

1000000.times do

mark = Party.new('Mark')
tom = Party.new('Tom')
st_marys = Party.new("St. Mary's")

a1 = Accountability.new(st_marys, mark, :appointment)
a2 = Accountability.new(st_marys, tom, :appointment)
a3 = Accountability.new(tom, mark, :supervision)
a4 = Accountability.new(tom, mark, :a)
a5 = Accountability.new(tom, mark, :b)
a6 = Accountability.new(tom, mark, :c)
a7 = Accountability.new(tom, mark, :d)
a8 = Accountability.new(tom, mark, :e)
a9 = Accountability.new(tom, mark, :f)

# keep objects in memory
parties.push(mark, tom, st_marys)
accountabilities.push(a1, a2, a3, a4, a5, a6, a7, a8, a9)

total_objects = parties.size + accountabilities.size

if total_objects % 10000 == 0
  memory_usage = `ps -o rss= -p #{Process.pid}`.to_i # in kilobytes
  puts "~#{total_objects} objects in memory = #{memory_usage} kb"
end

end

puts total_objects

# tests
=begin
puts st_marys.children.include?(mark)
puts mark.parents.include?(st_marys)

puts mark.parents.include?(st_marys)
puts mark.parents(:appointment).include?(st_marys)
puts mark.parents.size == 2
puts mark.parents(:appointment).size == 1
puts mark.parents(:supervision).size == 1
puts mark.parents(:supervision).include?(tom)

# cycle checking tests - will throw an exception
Accountability.new(mark, tom, :supervision)
=end
