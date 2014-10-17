class Node
  attr_reader :letter, :children, :full_word, :parent, :current_word

  def initialize(letter)
    @letter = letter
    @children = {}
    @full_word = false
    @parent = nil
    @current_word = ""
  end

  def add_child(node)
    raise "node value can not be blank" if node.letter == ''
    raise "node already exists" unless @children[ node.letter ].nil?
    @children[node.letter] = node
    node.set_parent(self)
    node.set_current_word(self)
  end

  def set_parent(parent_node)
    @parent = parent_node
  end

  def set_current_word(parent_node)
    @current_word = parent_node.current_word + @letter
  end

  def make_full
    @full_word = true
  end

  def self.add_word(word, root_node)
    if word == ''
      root_node.make_full
      return
    end
    letters = word.split('')
    letter = letters.shift
    if root_node.children[letter].nil?
      root_node.add_child(Node.new(letter))
    end
    Node.add_word(letters.join(''), root_node.children[letter])
  end

  def self.find_prefix(prefix, root_node)
    letters = prefix.split('')
    current_node = root_node
    letters.each do |letter|
      if current_node.children[letter]
        current_node = current_node.children[letter]
      else
        return nil
      end
    end
    current_node
  end

  def self.find_words(prefix, root_node)
    vertex = Node.find_prefix(prefix, root_node)
    return [] if vertex.nil?
    words = []
    words << vertex.current_word if vertex.full_word
    nodes = vertex.children.values
    until nodes.empty?
      current_node = nodes.shift
      nodes.push(*current_node.children.values)
      words << current_node.current_word if current_node.full_word
    end
    words
  end
  
  ## special methods for Ghost game ##
  def self.word_exist?(word, root_node)
    vertex = Node.find_prefix(word, root_node)
    return false if vertex.nil?
    return true if vertex.full_word
    false
  end

  def self.ghost_words(prefix, root_node) # => returns words of 4 letters length or longer
    vertex = Node.find_prefix(prefix, root_node)
    return [] if vertex.nil?
    words = []
    words << vertex.current_word if vertex.full_word && vertex.current_word.length > 3
    nodes = vertex.children.values
    until nodes.empty?
      current_node = nodes.shift
      nodes.push(*current_node.children.values)
      words << current_node.current_word if current_node.full_word
    end
    words
  end

  def self.best_words(prefix, root_node, word_length) # get a list of words that are exact length
    vertex = Node.find_prefix(prefix, root_node)
    return [] if vertex.nil?
    words = []
    if vertex.full_word && vertex.current_word.length == word_length
      words << vertex.current_word
    end
    nodes = vertex.children.values
    until nodes.empty?
      current_node = nodes.shift
      nodes.push(*current_node.children.values)
      if current_node.full_word && current_node.current_word.length == word_length
        words << current_node.current_word
      end
    end
    words
  end
end