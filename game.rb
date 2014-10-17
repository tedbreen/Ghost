require_relative 'lib\node'

class Game
  attr_reader :dictionary, :human_player, :game_word

  def initialize(file)
    @dictionary = Game.load_dictionary(file)
    @human_player = true  # human is true, computer is false
    @game_word = ''
  end

  def play
    puts "***** New game! Let's play! *****\n\n"
    @game_word = ''
    @human_player = true
    playing = true
    while playing
      puts "The game word is: '#{@game_word}'\n\n"
      # playing = human
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
    word = computer_words.shift.split('')
    letter = ''
    word.each_with_index do |char, idx|
      letter = char
      break if char != @game_word[idx]
    end
    letter_chosen(letter)
  end

  def computer_words
    options = []
    if @game_word.length == 1
      word_length = 5
    else
      word_length = @game_word.length + 2
    end
    while options.empty? || word_length > 100
      options.push(*Node.best_words(@game_word, @dictionary, word_length))
      word_length += 2 if options.empty?
    end
    p options unless @game_word.length < 3
    options
  end

  def choose_letter
    p Node.find_words(@game_word, @dictionary) unless @game_word == ''
    print "#{display_player(@human_player)}: Choose a letter (a-z): "
    letter = gets.chomp
    puts "" # blank
    return nil if letter.length > 1
    letter.ord < 97 || letter.ord > 122 ? nil : letter
  end

  def valid_letter?(letter)
    temp = @game_word + letter
    words = Node.ghost_words(temp, @dictionary)
    if words.length > 0
      true
    else
      puts "Invalid entry: your letter choice won't make a word\n\n"
      false
    end
  end

  def ends_game?(word)
    if Node.word_exist?(word, @dictionary) && word.length > 3
      puts "Game over! You spelled '#{@game_word}'\n\n"
      puts "#{display_player(@human_player)} loses!\n\n"
      true
    else
      false
    end
  end

  def display_player(player)
    player ? "Human" : "Computer"
  end

  def self.load_dictionary(file)
    start_time = Time.now
    puts "populating dictionary, this will take about a minute..."
    root = Node.new('')
    File.open('word_list.txt').each { |word| Node.add_word(word.chomp, root) }
    puts "That took #{Time.now - start_time} seconds.\n\n"
    root
  end

  def letter_chosen(letter)
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
end

game = Game.new('file_list.txt')
while true
  game.play
end