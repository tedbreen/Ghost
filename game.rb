require_relative 'lib\node'

class Game
  attr_reader :dictionary, :human_player, :game_word

  def initialize(file)
    @dictionary = Game.load_dictionary(file)
    @human_player = true  # human is true, computer is false
    @game_word = ''
  end

  def play
    puts "New game! Let's play!\n\n"
    @game_word = ''
    @human_player = true
    playing = true
    while playing
      puts "The game word is: '#{@game_word}'\n\n"
      letter = choose_letter
      if letter.nil?
        puts "Invalid entry: must be a single letter from a to z\n\n"
      else
        if valid_letter?(letter)
          @game_word += letter
          if ends_game?(@game_word)
            puts "Game over! You spelled '#{@game_word}'"
            puts "#{display_player(@human_player)} loses!\n\n"
            playing = false
          else
            @human_player = !@human_player
          end
        else
          puts "Invalid entry: your letter choice won't make a word\n\n"
        end
      end
    end
  end

  def choose_letter
    print "Choose a letter (a-z): "
    letter = gets.chomp
    return nil if letter.length > 1
    letter.ord < 97 || letter.ord > 122 ? nil : letter
  end

  def valid_letter?(letter)
    temp = @game_word + letter
    words = Node.ghost_words(temp, @dictionary)
    words.length > 0 ? true : false
  end

  def ends_game?(word)
    if Node.word_exist?(word, @dictionary) && word.length > 3
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
end

game = Game.new('file_list.txt')
while true
  game.play
end