require 'set'

class Accountability
  attr_reader :child, :parent, :accountability_type
  
  def initialize(params)
  
    @child = params[:child]
    @parent = params[:parent]
    @accountability_type = params[:accountability_type]
    
    @parent.add_child(self)
    @child.add_parent(self)
  end
  
  def to_s
    "#{parent.name} -> #{accountability_type.to_s} -> #{child.name}"
  end
end

class User
  attr_reader :name, :parent_accountabilities, :child_accountabilities
  
  def initialize(name)
    @name = name
    @parent_accountabilities = Set.new
    @child_accountabilities = Set.new
  end
  
  def add_child(child)
    @child_accountabilities.add(child)
  end
  
  def add_parent(parent)
    @parent_accountabilities.add(parent)
  end
  
  def parents
    @parent_accountabilities.to_a
  end
  
  def children
    @child_accountabilities.to_a
  end
  
  def to_s
    <<-EOV
    #{self.name}
    \tparents: #{self.parents.map(&:to_s)}
    \tchildren: #{self.children.map(&:to_s)}
    EOV
  end
  
end

# testing
pa = User.new 'Teacher A'
sa = User.new 'Student A'

aptos = Accountability.new :parent => pa, :child => sa, :accountability_type => :teacher
astop = Accountability.new :child => pa, :parent => sa, :accountability_type => :student

puts pa.to_s
puts sa.to_s

