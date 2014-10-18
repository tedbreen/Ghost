require_relative 'lib\node.rb'

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
while true
  print "enter a prefix: "
  prefix = gets.chomp
  p Node.find_words(prefix, root)
end