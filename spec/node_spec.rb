require 'node'
require 'rspec'

describe Node do
  it "should be created with a letter or blank string value" do
    expect { Node.new }.to raise_error
  end

  subject(:root_node) { Node.new("") }
  subject(:first_node) { Node.new("a") }
  subject(:second_node) { Node.new("n") }
  subject(:third_node) { Node.new("t") }

  describe '#letter' do
    it "should return letter value" do
      expect(root_node.letter).to eq("")
      expect(first_node.letter).to eq("a")
    end
  end

  describe '#children' do
    it "should return children hash" do
      expect(root_node.children).to eq({})
    end
  end

  describe '#add_child' do
    subject(:blank_node) { Node.new("") }
    subject(:dup_node) { Node.new("a") }

    it "should add a node to the children hash" do
      root_node.add_child(first_node)
      expect(root_node.children).to eq( {"a" => first_node} )
    end

    it "should not add a child if child letter is blank string" do
      expect { root_node.add_child(blank_node) }.to raise_error
    end

    it "should not add a child if it already exists" do
      root_node.add_child(first_node)
      expect { root_node.add_child(dup_node) }.to raise_error
    end

    it "should set the parent value of the child" do
      root_node.add_child(first_node)
      expect(first_node.parent).to eq(root_node)
    end

    it "should store current word in child" do
      root_node.add_child(first_node)
      first_node.add_child(second_node)
      second_node.add_child(third_node)
      expect(third_node.prefix).to eq("ant")
    end
  end

  describe '::add_word' do
    it "adds a word to the root node in the trie" do
      Node.add_word("ant", root_node)
      last_node = root_node.children["a"].children["n"].children["t"]
      expect(last_node.letter).to eq("t")
      expect(last_node.full_word).to eq(true)
    end

    it "does not create conflict with common prefixes already in trie" do
      Node.add_word("crock", root_node)
      Node.add_word("croak", root_node)
      middle_node = root_node.children["c"].children["r"].children["o"]
      expect(middle_node.children.keys.sort).to eq(["a", "c"])
    end
  end

  describe '::find_word' do
    it "returns list of words that have that have a given prefix" do
      Node.add_word("have", root_node)
      Node.add_word("heck", root_node)
      Node.add_word("helicopter", root_node)
      Node.add_word("hell", root_node)
      Node.add_word("hello", root_node)
      Node.add_word("hero", root_node)
      Node.add_word("happens", root_node)
      Node.add_word("happy", root_node)
      expect(Node.find_word("hex", root_node)).to eq([])
      expect(Node.find_word("hel", root_node).sort).to eq(
        ["hello", "hell", "helicopter"].sort
      )
    end
  end
end