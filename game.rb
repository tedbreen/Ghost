require_relative 'lib\node'

def display_player(boolean)
  unless (boolean == true) || (boolean == false)
    raise "must be true or false"
  end
  boolean ? "Human" : "Computer"
end

def play_game(trie)
  game_string = ''
  current_player = true # true is human, false is computer
  while true
    puts "Game string: '#{game_string}'"
    print "#{display_player(current_player)}, choose a letter: "
    choice = gets.chomp
    options = Node.ghost_words((game_string + choice), trie)
    if options.length > 0
      game_string += choice
      current_player = !current_player
    else
      puts "that letter won't work. try again"
    end
    if game_string.length > 3 && Node.word_exist?(game_string, trie)
      puts "Game over"
      break
    end
  end
end

root = Node.new('')
puts "populating dictionary, this will take a while..."
start_time = Time.now
File.open('word_list.txt').each { |word| Node.add_word(word.chomp, root) }
puts "That took #{Time.now - start_time} seconds.\n\n"

while true
  puts "let's play Ghost!"
  play_game(root)
  print "that was fun. play again? (y/n)"
  selection = gets.chomp
  break if selection == 'n'
end