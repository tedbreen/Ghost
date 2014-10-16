class Node
  attr_reader :letter, :children, :full_word, :parent, :prefix

  def initialize(letter)
    @letter = letter
    @children = {}
    @full_word = false
    @parent = nil
    @prefix = ""
  end

  def add_child(node)
    raise "node value can not be blank" if node.letter == ''
    raise "node already exists" unless @children[ node.letter ].nil?
    @children[node.letter] = node
    node.set_parent(self)
    node.set_prefix(self)
  end

  def set_parent(parent_node)
    @parent = parent_node
  end

  def set_prefix(parent_node)
    @prefix = parent_node.prefix + @letter
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

  def self.find_word(prefix, root_node)
    letters = prefix.split('')
    current_node = root_node
    letters.each do |letter|
      if current_node.children[letter]
        current_node = current_node.children[letter]
      else
        return []
      end
    end
    current_node.children.keys
  end
end