## Ghost

In the game of [Ghost](http://en.wikipedia.org/wiki/Ghost_(game)), two players take turns building up an English word from left to right. Each player adds one letter per turn. The goal is to not complete the spelling of a word: if you add a letter that completes a word (of 4+ letters), or if you add a letter that produces a string that cannot be extended into a word, you lose. (Bluffing plays and "challenges" may be ignored for the purpose of this puzzle.)

To play the game, clone this repo and run `ruby game.rb` on the command line.

### Directions

Write a program that allows a user to play Ghost against the computer.

The computer should play optimally given the following dictionary: `word_list.txt`. Allow the human to play first. If the computer thinks it will win, it should play randomly among all its winning moves; if the computer thinks it will lose, it should play so as to extend the game as long as possible (choosing randomly among choices that force the maximal game length).

*Bonus question: if the human starts the game with 'n', and the computer plays according to the strategy above, what unique word will complete the human's victory?*

### Results

1. Implemented a [trie](http://en.wikipedia.org/wiki/Trie) to store all the words from the text file. See `lib/node.rb`
  * Words are added by splitting into array of characters and adding each character recursively.
  * Each node contains variables that store the letter, parent,  children, the word up that is spelled starting from the root, and whether or not that node completes a full word.
2. Implemented game play with a game class that includes human and computer moves. Human moves are pretty straightforward: pick a letter and start making a word. Computer moves are based on an algorithm that finds all words that can be formed from the current game word.
  a. Computer first tries to find a letter that can only produce words with an odd number of letters.  That forces human to complete a word.
  b. If such a case does not exist, the computer than selects the letter than can lead to the longest word from the current game word.
  c. This is repeated every time the computer plays.  Computer can't always force an odd-numbered-length word on its first move, but often can on its second.
  d. Current list of letters that a human can start with to beat the computer: a, h, k, n, p, r, w. (bonus question was apparently not solved)

### Notes

1. Loading the dictionary with my trie is quite slow right now.  It can take 30-45 seconds to parse the list of 173k+ words.
2. Only words that are 4 letters or longer are loaded.
3. Words with common prefixes are not added if the prefix itself is a full word. Example: "them" is added, but "themselves" is not. The word "themselves" will never be spelled, because the game will end once "them" is spelled.