
=begin
 A node for a red black tree
 Nodes must be red or black
 Leaf nodes are a constant nil node that is black to simplify algorithms
=end

class RedBlackNode
  
  attr_accessor :data
  attr_accessor :parent
  attr_accessor :left
  attr_accessor :right
  attr_accessor :color
  
  Red = 0
  Black = 1
  BlackBlack = 2
  
  Nil = RedBlackNode.new
  Nil.color = Black
  def Nil.parent=(node)
    #The Nil node should have no parent
  end
  def Nil.data=(data)
    #The Nil node should have no data
  end
  
  def initialize(data = nil)
    @data = data
    @color = Red
    @parent = nil
    @left = Nil
    @right = Nil
  end
  
  def to_s
    if @data
      data = @data
    else
      data = 'nil'
    end
    
    if @color == Red
      color = 'R'
    elsif @color == Black
      color = 'B'
    else
      color = 'BB'
    end
    
    data.to_s + color
  end

end


=begin
 A red black tree is a binary search tree that is approximately balanced
 The following rules ensure the tree remains balanced
 1) All nodes are red or black
 2) The root is black
 3) The leaf nodes are black
 4) Both children of red nodes are black
 5) All simple paths from a given node to a leaf has the same number of black nodes
=end
class RedBlackTree
  
  def initialize
    @root = nil
    @str = ""
  end
  
  def search(key)
    search_node(key).data
  end
  
=begin
 Inserts the given data into the tree
 If the data in the tree cannot be compared to each other, errors will occur
 Marks the string representation as needing to be built
 @param data the data to be stored in the tree
=end
  def insert(data)
    if data
      insert_node(RedBlackNode.new(data))
      @str = ""
    end
    self
  end
  
=begin
  Recursively builds a string representing the tree if the string does not already exist
  The string is built using in order traversal
  The string created is on one line, so large trees will be unwieldy
=end
  def to_s
    build_s(@root) if @root and @str == ""
    @str
  end
  
  def print_tree
    depth = 0
    while print_depth(@root, depth) > 0
      depth += 1
      puts
    end
  end
  
  
  protected
  
  def print_depth(node, depth)
    count = 0
    
    if depth == 0
      print(node.to_s + ' ') #if node != RedBlackNode::Nil
      count = 1
    else
      count += print_depth(node.left, depth - 1) if node != RedBlackNode::Nil
      count += print_depth(node.right, depth - 1) if node != RedBlackNode::Nil
    end
    
    count
  end
  
=begin
  Recursive method to build the string representation of the tree
=end
  def build_s(node)
    build_s(node.left) if node.left != RedBlackNode::Nil
    @str += node.to_s + ' '
    build_s(node.right) if node.right != RedBlackNode::Nil
  end
  
=begin
 TODO 
=end
  def search_node(key)
    current = @root
    
    while current != RedBlackNode::Nil and current.data != key
      if key < current.data
        current = current.left
      else
        current = current.right
      end
    end
    
    current
  end
  
=begin
  Insert the node as red using a standard binary tree insertion
  If the parent of the inserted node is red, then the tree must be fixed
  @param node the node to be inserted into the tree
=end
  def insert_node(node)
    if @root == nil
      #The root must be black
      @root = node
      node.color = RedBlackNode::Black
      
    else
      parent = nil
      current = @root
      
      #Find the parent of the node to be inserted
      while current != RedBlackNode::Nil
        parent = current
        
        if(node.data < current.data)
          current = current.left
        else
          current = current.right
        end
      end
      
      #Link the pointers for the parent and child
      node.parent = parent
      if node.data < parent.data
        parent.left = node
      else
        parent.right = node
      end
      
      #If the parent node is red, the tree must be fixed
      if parent.color == RedBlackNode::Red
        fixup_insert node
      end
      
    end
    
  end
  
=begin
  Fixes the tree after an insertion based on the given error node
  Because nodes are inserted as red, only rule 4 can be broken
  @param error the node that broke the red black rules
=end
  def fixup_insert(error)
    
    #Keep going until the root is hit, or two red nodes are no longer adjacent
    while error.color == RedBlackNode::Red and error.parent.color == RedBlackNode::Red
      #Set up family pointers
      #Since both the error and the parent are red, neither can be the root so the grandparent must exist
      parent = error.parent
      grandparent = parent.parent
      if parent == grandparent.left
        uncle = grandparent.right
      else
        uncle = grandparent.left
      end
      
      #Case 1: The uncle is red
      #Pull a black down from the grandparent and move the error node up to the grandparent
      #The root must remain black
      #This may resolve the issue
      if uncle.color == RedBlackNode::Red
        parent.color = RedBlackNode::Black
        uncle.color = RedBlackNode::Black
        
        if grandparent != @root
          grandparent.color = RedBlackNode::Red
        end
        error = grandparent
        
      #Case 2: The uncle is black and the error node is closer to the uncle
      #Rotate the parent so that the error node is farther from the uncle
      #This will not resolve the issue
      elsif (uncle == grandparent.right and error == parent.right) or
        (uncle == grandparent.left and error == parent.left)
        rotate_edge(parent, error)
        error = parent
        
      #Case 3: The uncle is black and the error node is farther from the uncle
      #Rotate the grandparent away from the error node
      #This will resolve the issue
      else
        rotate_edge(grandparent, parent)
      end
    end
    
  end
  
=begin
 Rotates the given edge away from the child
 Thus, if the child is on the right, it is left rotated
 And if the child is on the left, it is right rotated
 The colors are also swapped to maintain consistency
 @param parent the parent node of the edge to be rotated
 @param child the child node of the edge to be rotated
=end
  def rotate_edge(parent, child)
    if parent.right == child
      rotate_left parent
    else
      rotate_right parent
    end
    
    parent.color, child.color = child.color, parent.color
  end

=begin
 Rotate the given node left
 @param parent the parent node of the edge to be rotated
=end
  def rotate_left(parent)
    child = parent.right
    
    #Attach the pointers for the grandparent
    grandparent = parent.parent
    child.parent = grandparent
    if grandparent == nil
      @root = child
    elsif grandparent.left == parent
      grandparent.left = child
    else
      grandparent.right = child
    end
    parent.parent = child
    
    #Attach the pointers for the child
    parent.right = child.left
    parent.right.parent = parent
    child.left = parent
  end

=begin
 Rotate the given node right
 @param parent the parent node of the edge to be rotated
=end
  def rotate_right(parent)
    child = parent.left
    
    #Attach the pointers for the grandparent
    grandparent = parent.parent
    child.parent = grandparent
    if grandparent == nil
      @root = child
    elsif grandparent.left == parent
      grandparent.left = child
    else
      grandparent.right = child
    end
    parent.parent = child
    
    #Attach the pointers for the child
    parent.left = child.right
    parent.left.parent = parent
    child.right = parent
  end
end


if __FILE__ == $0
  
  tree = RedBlackTree.new
  tree.insert 4
  tree.insert 5
  tree.insert 3
  tree.insert 2
  puts tree
  #tree.print_tree
  
end