require_relative 'lib\node'

class Game
  attr_reader :dictionary, :human_player, :game_word

  def initialize(file)
    @dictionary = Game.load_dictionary(file)
    @human_player = true  # human is true, computer is false
    @game_word = ''
    @alphabet = ('a'..'z').to_a
  end

  def play
    puts "***** New game! Let's play! *****\n\n"
    @game_word = ''
    @human_player = true
    playing = true
    while playing
      puts "The game word is: '#{@game_word}'\n\n"
      if @human_player
        playing = human
      else
        playing = computer
      end      
    end
  end

  def human
    letter = choose_letter
    if letter.nil?
      puts "Invalid entry: must be a single letter from a to z\n\n"
      true
    else
      letter_chosen(letter)
    end
  end

  def computer
    best_letter = ''
    longest_word = ''
    @alphabet.each do |letter|
      words = Node.find_words(@game_word + letter, @dictionary)
      next if words.length == 0
      all_odd = true
      words.each do |word|
        if word.length % 2 == 0
          all_odd = false
        end
        if word.length > longest_word.length
          best_letter = letter
          longest_word = word
        end
      end
      return letter_chosen(letter) if all_odd
    end
    letter_chosen(best_letter)
  end

  def choose_letter # => helper method for Game#human
    print "#{display_player(@human_player)}: Choose a letter (a-z): "
    letter = gets.chomp
    puts "" # blank
    return nil if letter.length > 1
    letter.ord < 97 || letter.ord > 122 ? nil : letter
  end

  def letter_chosen(letter) # => helper method for Game#human, Game#computer
    if valid_letter?(letter)
      puts "#{display_player(@human_player)} chooses '#{letter}'\n\n"
      @game_word += letter
      if ends_game?(@game_word)
        return false
      else
        @human_player = !@human_player
        return true
      end
    else
      return true
    end
  end

  def valid_letter?(letter) # => helper method for Game#letter_chosen
    temp = @game_word + letter
    words = Node.find_words(temp, @dictionary)
    if words.length > 0
      true
    else
      puts "Invalid entry: your letter choice won't make a word\n\n"
      false
    end
  end

  def ends_game?(word)  # => helper method for Game#letter_chosen
    if Node.word_exist?(word, @dictionary) && word.length > 3
      puts "Game over! #{display_player(@human_player)} spelled '#{@game_word}'\n\n"
      puts "#{display_player(@human_player)} loses!\n\n"
      true
    else
      false
    end
  end

  def display_player(player)
    player ? "Human" : "Computer"
  end

  def self.load_dictionary(file)  # => helper method for Game#initialize
    start_time = Time.now
    puts "loading dictionary with words. this will take a minute"
    root = Node.new('')
    File.open('word_list.txt').each do |line|
      word = line.chomp
      next if word.length < 4
      add_word = true
      current_word = ''
      word.split('').each do |letter|
        current_word += letter
        node = Node.find_prefix(current_word, root)
        if node && node.full_word
          add_word = false
          break
        end
      end
      Node.add_word(word, root) if add_word
    end
    puts "That took #{Time.now - start_time} seconds.\n\n"
    root
  end
end

game = Game.new('file_list.txt')
while true
  game.play
end