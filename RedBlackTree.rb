
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
  
=begin
 Searches the tree for a given key
 @param key the key to find in the tree
 @return the first data that matches the key
 @return nil if the key is not found 
=end
  def search(key)
    if key
      node = search_node key
      if node
        val = node.data
      end
    end
    
    val
  end
  
=begin
 Finds the data that is the successor of the given key
 @param key the key to find the successor of
 @return the data that is the successor
 @return nil if the key is not found or there is no successor 
=end
  def successor(key)
    if key
      node = search_node key
      if node
        succ = successor_node node
        if succ
          val = succ.data
        end
      end
    end
    
    val
  end
  
=begin
 Inserts the given data into the tree if it is not nil
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
 TODO 
=end
  def delete(key)
    if key
      node = search_node key
      
      if node
        removed = delete_node node
        data = removed.data
        @str = ""
      end
    end
    
    data
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
  
=begin
 Prints out the tree layer by layer including all leaf nodes
 Shows the structure of the tree 
=end
  def print_tree
    depth = 0
    while print_depth(@root, depth) > 0
      depth += 1
      puts
    end
    
    self
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
 Searches for the node with the given key value
 @param key the key value to search for
 @return the first node with data that matches the key value
 @return nil if no node is found
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
    
    current = nil if current == RedBlackNode::Nil
    current
  end
  
=begin
 Finds the minimum node of a given subtree
 @param node the root of the subtree to check
 @return the node with the minimum value in the subtree
=end
  def min_node(node)
    while node.left != RedBlackNode::Nil
      node = node.left
    end
    
    node
  end
  
=begin
 Finds the maximum node of a given subtree
 @param node the root of the subtree to check
 @return the node with the maximum value in the subtree
=end
  def max_node(node)
    while node.right != RedBlackNode::Nil
      node = node.right
    end
    
    node
  end
  
=begin
  Finds the successor node of the given node
  @param node the node to find the successor to
  @return the node that is the successor
  @return nil if there is no successor
=end
  def successor_node(node)
    #If the node has a right child, the successor is the minimum node in the subtree rooted
    #at the right child
    if node.right != RedBlackNode::Nil
      succ = min_node node.right
      
    #Otherwise, traverse up the tree until the the node is less than the parent, or the root
    #is hit. The parent is the successor if the root is not hit.
    else
      parent = node.parent
      while parent and node == parent.right
        node = parent
        parent = parent.parent
      end
      succ = parent
    end
    
    succ
  end
  
=begin
 TODO 
=end
  def delete_node(node)
    #If the left child does not exist, then the node itself is removed, and the replacement
    #node is the right child
    if node.left == RedBlackNode::Nil
      removed = node
      replacement = node.right
      
    #If the right child does not exist, then the node itself is removed, and the replacement
    #node is the left child
    elsif node.right == RedBlackNode::Nil
      removed = node
      replacement = node.left
      
    #If both children exist, then the successor node is removed, and the replacement node is
    #the right child of the node that was removed
    #The data is then swapped so the correct data is removed
    else
      removed = min_node(node.right)
      replacement = removed.right
      node.data, removed.data = removed.data, node.data
    end
    
    #Replace the node to be removed with the replacement node
    if removed.parent == nil
      @root = replacement
    elsif removed.parent.left == removed
      removed.parent.left = replacement
    else
      removed.parent.right = replacement
    end
    replacement.parent = removed.parent
    
    #If the node that was removed is black, then the tree needs to be fixed
    if removed.color == RedBlackNode::Black
      #Give the removed node's color to the replacement node and then fix the tree
      replacement.color = RedBlackNode::BlackBlack
      fixup_delete(replacement, removed.parent)
    end
    
    removed
  end
  
=begin
  TODO
=end
  def fixup_delete(error, parent)
    
    while error != @root and error.color == RedBlackNode::BlackBlack
      #Set the family pointers
      parent = error.parent if error.parent
      if error == parent.left
        sibling = parent.right
        closer = sibling.left
        further = sibling.right
      else
        sibling = parent.left
        closer = sibling.right
        further = sibling.left
      end
      
      #Case 1: The sibling is red
      #Rotate the parent towards the error node
      #This will not fix the problem
      if sibling.color == RedBlackNode::Red
        rotate_edge(parent, sibling)
        
      #Case 2: The sibling is black with two black children
      #Pull a black up to the parent
      #The parent becomes the new error node
      #This may fix the problem
      elsif sibling.left.color != RedBlackNode::Red and sibling.right.color != RedBlackNode::Red
        sibling.color = RedBlackNode::Red
        error.color = RedBlackNode::Black
        parent.color += RedBlackNode::Black
        error = parent
        
      #Case 3: The sibling is black and the further niece is black
      #Rotate the sibling away from the closer niece
      #This will make the further niece red for case 4
      elsif further.color != RedBlackNode::Red
        rotate_edge(sibling, closer)
        
      #Case 4: The sibling is black and the further niece is red
      #Give the error node's extra black to the further niece and rotate the parent
      #node away from the sibling
      #This will fix the problem
      else
        further.color = RedBlackNode::Black
        error.color = RedBlackNode::Black
        rotate_edge(parent, sibling)
      end
      
    end
    
    #The root may have become double black from case two
    @root.color = RedBlackNode::Black
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
  tree.insert 3
  tree.insert 1
  tree.insert 10
  tree.insert 0
  tree.insert 2
  tree.insert(-1)
  puts tree
  tree.print_tree
  tree.delete 1
  puts tree
  tree.print_tree
  tree.delete 10
  puts tree
  tree.print_tree
  #tree.print_tree
  
end