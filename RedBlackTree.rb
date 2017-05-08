#Author: Benjamin Kleinberg


=begin
 A red black tree is a binary search tree that is approximately balanced
 All methods (except the print methods) have time complexity of log n
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
 @return the data of the first node that matches the key
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
 Finds the data of the node that is the successor of the node with the given key
 @param key the key for the node to find the successor of
 @return the data of the node that is the successor
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
 Gets the data with the minimum value in the tree
 @return the data of the node with the minimum value
 @return nil if the tree is empty 
=end
  def min
    val = min_node(@root).data if @root
    val
  end
  
  
=begin
 Gets the data with the maximum value in the tree
 @return the data of the node with the maximum value
 @return nil if the tree is empty 
=end
  def max
    val = max_node(@root).data if @root
    val
  end
  
  
=begin
 Inserts the given data into the tree if the data is not nil
 New nodes are inserted as red
 If the data in the tree cannot be compared to each other, errors will occur
 @param data the data to be stored in the tree
 @return self
=end
  def insert(data)
    if data
      insert_node(RedBlackNode.new(data))
      #Mark the string representation as needing to be built
      @str = ""
    end
    
    self
  end
  
  
=begin
 Deletes the first node with the given key from the tree if the key is not nil
 @param key the key for the node to be deleted
 @return the data that was deleted from the node
 @return nil if the key is nil or the node was not found
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
  Get an in-order string representation of the tree
  The string created is on one line, so large trees will be unwieldy
  @return the string representation of the tree
=end
  def to_s
    #Only build the string if it needs to be created
    build_s(@root) if @root and @str == ""
    @str
  end
  
  
=begin
 Print out the structure of the tree
 Prints out the tree layer by layer including all leaf nodes
 @return self
=end
  def print_tree
    depth = 0
    if @root
      #Print each layer until a layer has no children
      while print_depth(@root, depth) > 0
        depth += 1
        puts
      end
    end
    
    self
  end
  
  
  protected
  
=begin
 Searches for the node with the given key
 @param key the key to search for
        key is assumed to be non-nil
 @return the first node with data that matches the key
 @return nil if no node is found
=end
  def search_node(key)
    current = @root
    
    #Keep traveling down until the node matches the key
    while current != Nil and current.data != key
      if key < current.data
        current = current.left
      else
        current = current.right
      end
    end
    
    #Convert the red black Nil into nil
    current = nil if current == Nil
    current
  end
  
  
=begin
  Finds the successor node of the given node
  @param node the node to find the successor of
         node is assumed to be non-nil
  @return the node that is the successor
  @return nil if there is no successor
=end
  def successor_node(node)
    #If the node has a right child, the successor is the minimum node in the subtree rooted
    #at the right child
    if node.right != Nil
      succ = min_node node.right
      
    #Otherwise, traverse up the tree until the node is less than the parent, or the root
    #is hit. The successor is the parent if the root is not hit.
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
 Finds the minimum node of the given subtree
 @param node the root of the subtree to check
        node is assumed to be non-nil
 @return the node with the minimum value in the subtree
=end
  def min_node(node)
    while node.left != Nil
      node = node.left
    end
    
    node
  end
  
  
=begin
 Finds the maximum node of a given subtree
 @param node the root of the subtree to check
        node is assumed to be non-nil
 @return the node with the maximum value in the subtree
=end
  def max_node(node)
    while node.right != Nil
      node = node.right
    end
    
    node
  end
  
  
=begin
  Insert the given node into the tree
  @param node the node to be inserted into the tree
         node is assumed to be non-nil
  @return nil
=end
  def insert_node(node)
    #If the tree does not exist, insert the node as the root and make it black
    if @root == nil
      @root = node
      node.color = Black
      
    else
      parent = nil
      current = @root
      
      #Find the parent of the node to be inserted
      while current != Nil
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
      
      #If the parent node is red, then the tree must be fixed
      if parent.color == Red
        fixup_insert node
      end
      
    end
    
    nil
  end


=begin
  Fixes the tree after an insertion
  Because nodes are inserted as red, only rule 4 can be broken
  @param error the node that broke the red black rules
  @return nil
=end
  def fixup_insert(error)
    
    #Keep going until the root is hit, or two red nodes are no longer adjacent
    while error.color == Red and error.parent.color == Red
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
      if uncle.color == Red
        parent.color = Black
        uncle.color = Black
        
        if grandparent != @root
          grandparent.color = Red
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
    
    nil
  end
  
  
=begin
 Deletes the given node from the tree
 @param node the node to be deleted from the tree
        node is assumed to be non-nil
 @return the node that was removed from the tree
=end
  def delete_node(node)
    #If the left child does not exist, then the node itself is removed, and the replacement
    #node is the right child
    if node.left == Nil
      removed = node
      replacement = node.right
      
    #If the right child does not exist, then the node itself is removed, and the replacement
    #node is the left child
    elsif node.right == Nil
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
    
    #If the tree becomes empty, reset the root to nil
    if @root == Nil
      @root = nil
    
    else
      replacement.parent = removed.parent
      
      #Give the removed node's color to the replacement node
      replacement.color += Black
      #If the replacement node is now double black, then the tree needs to be fixed
      fixup_delete(replacement, removed.parent) if replacement.color == BlackBlack
    end
    
    removed
  end
  
  
=begin
  Fixes the tree after a deletion
  
  @param error the node that broke the red black rules
         error is assumed to be non-nil, but possibly Red Black Nil
  @param parent the parent of the error node
         parent is assumed to be non-nil
  @return nil
=end
  def fixup_delete(error, parent)
    
    #Keep going until the error node has a valid color
    while error.color == BlackBlack
      #Set the family pointers
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
      if sibling.color == Red
        rotate_edge(parent, sibling)
        
      #Case 2: The sibling is black with two black children
      #Pull a black up to the parent
      #The parent becomes the new error node
      #This may fix the problem
      elsif sibling.left.color != Red and sibling.right.color != Red
        sibling.color = Red
        error.color = Black
        parent.color += Black
        error = parent
        parent = error.parent
        #If the root is hit, reset it to black and the problem is solved
        error.color = Black if error == @root
        
      #Case 3: The sibling is black and the further niece is black
      #Rotate the sibling away from the closer niece
      #This will make the further niece red for case 4
      elsif further.color != Red
        rotate_edge(sibling, closer)
        
      #Case 4: The sibling is black and the further niece is red
      #Give the error node's extra black to the further niece and rotate the parent
      #node away from the sibling
      #This will fix the problem
      else
        further.color = Black
        error.color = Black
        rotate_edge(parent, sibling)
      end
    end
    
    nil
  end
  
  
=begin 
  Build the string rooted at the given subtree
  Recursively traces downwards to build the entire subtree
  @param node the root of the subtree to build the string of
         node is assumed to be non-nil
  @return nil
=end
  def build_s(node)
    build_s(node.left) if node.left != Nil
    @str += node.to_s + ' '
    build_s(node.right) if node.right != Nil
    
    nil
  end
  
  
=begin
 Prints the nodes with the given depth
 Recursively traces downwards to get to the correct depth, skipping trees that are nil
 @param node the root of the subtree to print
        node is assumed to be non-nil, but can be red black Nil
 @param depth the depth to be printed (0 is the root)
        depth is assumed to be non-nil 
 @return the number of children of the printed nodes
=end
  def print_depth(node, depth)
    count = 0
    
    #Print the node if this is the desired depth
    if depth == 0
      print(node.to_s + ' ')
      count = 1
      
    #Otherwise, recursively print the left and right subtrees as long as they exist
    else
      count += print_depth(node.left, depth - 1) if node != Nil
      count += print_depth(node.right, depth - 1) if node != Nil
    end
    
    count
  end
  
  
=begin
 Rotates the given edge away from the child
 Thus, if the child is on the right, it is left rotated
 And if the child is on the left, it is right rotated
 The colors are also swapped to maintain consistency
 @param parent the parent node of the edge to be rotated
        parent is assumed to be non-nil
 @param child the child node of the edge to be rotated
        child is assumed to be non-nil
        child is assumed to be the child of parent
 @return nil
=end
  def rotate_edge(parent, child)
    if parent.right == child
      rotate_left parent
    else
      rotate_right parent
    end
    
    parent.color, child.color = child.color, parent.color
    nil
  end


=begin
 Rotate the given node left
 @param parent the parent node of the edge to be rotated
        parent is assumed to be non-nil
        the right child is assumed to be non-nil
 @return nil
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
    
    nil
  end


=begin
 Rotate the given node right
 @param parent the parent node of the edge to be rotated
        parent is assumed to be non-nil
        the left child is assumed to be non-nil
 @return nil
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
    
    nil
  end
  
  
=begin
 A node for the red black tree
 Nodes must be red or black
=end
  Red = 0
  Black = 1
  BlackBlack = 2
  class RedBlackNode
    
    attr_accessor :data
    attr_accessor :parent
    attr_accessor :left
    attr_accessor :right
    attr_accessor :color
    
    #Leaf nodes are a constant Nil node that is black to simplify algorithms
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
        data = @data.to_s
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
      
      data + '[' + color + ']'
    end
  end
  
  Nil = RedBlackNode::Nil
  
end




if __FILE__ == $0
  
end