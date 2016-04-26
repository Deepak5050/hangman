require 'yaml'

class Hangman
	attr_accessor :word, :guess, :missed

	def initialize
		@word = get_random_word #method to select a random word
		@guess = set_default_guess_array
		@guess_letter = ''
		@missed = []
	end

	def get_random_word
		words = File.read("5desk.txt")#reads the file 5desk.txt
		words = words.split()
		words = words.select { |word| word.size.between?(2, 4)}
		index = words.size
		random_word = words[rand(index)]
		random_word.split('')
	end

	def set_default_guess_array
		guess_array = []
		(@word.size).times { guess_array << '_'}
		guess_array
	end

	def guess_word(input = get_input)

		@word.each_index do |i|
			if @word[i].downcase == input.downcase
				@guess[i] = @word[i] 
			end
		end
		puts "Your guess: #{@guess}"
		@guess_letter = input	
	end

	def missed_letter
		@missed << @guess_letter if @word.all? { |letter| letter != @guess_letter}
		puts "missed: #{@missed}"
		puts ""
	end

	def play
		turn = 1
		welcome_message
		while turn < 9
			puts "turn: #{turn}"
			puts "Please enter a letter"
			guess_word
			missed_letter
			if @word == @guess
				puts "congrats! you guessed it right."
				turn += 10
			end
			turn += 1
		end
		puts "You lost the game. The correct word was '#{@word}'"
	end	

	def load_game
		content = File.open('games/hangman_saved.yaml')
		YAML.load(content)
	end

	
	def save_game
		Dir.mkdir('games') unless Dir.exists?('games')
		filename = ('games/hangman_saved.yaml')
		File.open(filename, 'w') do | file |
			file.puts YAML.dump(self)
		end
	end

	private
	def get_input
		input = gets.chomp
			if input == 'save'
				save_game
				puts "Game has been saved"
			elsif input == 'load'
				game = load_game
				game.play
				
			else
				until input.length == 1 && input.to_i == 0
					puts "Only one letter please. No integers allowed!"
					input = gets.chomp
					input
				end
			end
			input
	end



	def welcome_message
		puts ""
		puts "------------------------------------------------"
		puts "          Welcome to H-A-N-G-M-A-N game         "
		puts "------------------------------------------------"
		puts "\n \n"
		puts "* Computer will set a random word"
		puts "* You have 8 turns to guess it right to win the game"
		puts "* Follow the missed letters closely"
		puts "* You can save the game anytime by typing 'save'"
		puts "* You can load the previous game by typing 'load'"
		puts "\n \n"
		puts "Let's start the game"
		puts "\n \n"
		puts "Computer has selected a word"
		puts "#{guess}"
		puts "\n"
	end
end

hangman = Hangman.new
hangman.play