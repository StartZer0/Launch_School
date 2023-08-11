# This class will be used to track total score and determine grand winner
class Score
  attr_accessor :score

  SCORE_TO_WIN = 10
  RESET = 0
  def initialize
    @score = 0
  end

  def check_grand_score
    @score == SCORE_TO_WIN
  end

  def reset_score
    @score = RESET
  end

  def increment_score
    @score += 1
  end
end

class MoveType
  attr_accessor :value

  def win_condition(win_condition, choice)
    win_condition.include?(choice)
  end
end

class Paper < MoveType
  WIN_CONDITION = ['rock', 'spock']

  def initialize
    super()
    @value = 'paper'
  end
end

class Scissors < MoveType
  WIN_CONDITION = ['paper', 'lizard']

  def initialize
    super()
    @value = 'scissors'
  end
end

class Lizard < MoveType
  WIN_CONDITION = ['paper', 'spock']

  def initialize
    super()
    @value = 'lizard'
  end
end

class Spock < MoveType
  WIN_CONDITION = ['rock', 'scissors']

  def initialize
    super()
    @value = 'spock'
  end
end

class Rock < MoveType
  WIN_CONDITION = ['lizard', 'scissors']

  def initialize
    super()
    @value = 'rock'
  end
end

class Move
  VALUES = %w(rock paper lizard spock scissors)
  OBJECTS = [Rock.new, Paper.new, Scissors.new, Lizard.new, Spock.new]
  attr_accessor :moves

  def initialize
    @moves = {}
  end

  # Push all moves into hash to track players moves
  def track_moves(human_move, computer_move, human, computer)
    @moves[human.name] ||= []
    @moves[human.name].push(human_move)

    @moves[computer.name] ||= []
    @moves[computer.name].push(computer_move)
  end

  def human_win?(human_move, computer_move)
    OBJECTS.any? do |object|
      object.win_condition(object.class::WIN_CONDITION,
                           computer_move) && object.value == human_move
    end
  end

  def display_winner(winner, human, computer)
    case winner
    when :human
      human.increment_score
      puts "=> #{human.name} won!"
    when :computer
      computer.increment_score
      puts "=> #{computer.name} won!"
    else
      puts "=> It's a tie!"
    end
  end

  def determine_winner(human, computer)
    human_move = human.move
    computer_move = computer.move

    if human_move == computer_move
      display_winner(:tie, human, computer)
    elsif human_win?(human_move, computer_move)
      display_winner(:human, human, computer)
    else
      display_winner(:computer, human, computer)
    end
    track_moves(human_move, computer_move, human, computer)
  end
end

class Player < Score
  attr_accessor :name, :move
end

class Human < Player
  def initialize
    set_name
    super
  end

  def set_name
    name = ''
    loop do
      puts '=> Please, enter your name: '
      name = gets.chomp
      break unless name.empty?

      puts 'Sorry, you need to enter your name: '
    end
    self.name = name
  end

  def choose
    choice = nil
    loop do
      puts '=> Please, choose rock, paper, lizard, spock or scissors: '
      choice = gets.chomp.downcase
      break if Move::VALUES.include?(choice)

      puts 'Sorry, invalid choice.'
    end
    self.move = choice
  end
end

class Computer < Player
  NAMES = ['Android', 'Hal', 'R2D2']
  def initialize
    set_name
    super
  end

  def set_name
    self.name = NAMES.sample
  end

  def choose
    self.move = favored_choices.sample
  end

  private

  def favored_choices
    if name == 'Hal'
      return (['scissors'] * 4) + ['rock'] + (['lizard',
                                               'spock'] * 2)
    end
    return ['rock'] if name == 'R2D2'
    Move::VALUES
  end
end

class RPSGame
  attr_accessor :human, :computer, :moves

  def initialize
    @human = Human.new
    @computer = Computer.new
    @moves = Move.new
  end

  def display_welcome_message
    puts "=> Welcome #{human.name} to Rock, Paper, Lizard, Spock, Scissors!"
    puts "You need to win 10 times to become a grand winner"
  end

  def display_choices
    puts "=> #{human.name} chose #{human.move}"
    puts "=> #{computer.name} chose #{computer.move}"
  end

  def display_score
    puts "=> #{human.name} score: #{human.score}"
    puts "=> #{computer.name} score: #{computer.score}"
  end

  def display_moves
    moves.moves.each do |player, moves|
      puts "=> #{player} moves: #{moves.join(' ')} "
    end
  end

  def display_players_stats
    display_choices
    display_score
    display_moves
  end

  def display_goodbye_message
    puts 'Thanks for playing Rock, Paper, Lizard, Spock, Scissors. Good bye!'
  end

  def play_again?
    answer = ''
    loop do
      puts '=> Would you like to play again? Enter: y or n'
      answer = gets.chomp.downcase
      break if ['y', 'n'].include?(answer)

      puts 'Sorry, must be y or n'
    end
    return true if answer == 'y'

    false
  end

  def grand_winner
    return computer if computer.check_grand_score
    return human if human.check_grand_score
  end

  def display_grand_winner(player)
    puts "=> #{player.name} is a grand winner!"
    computer.reset_score
    human.reset_score
    moves.moves = {}
  end

  def game_flow
    loop do
      human.choose
      computer.choose
      moves.determine_winner(human, computer)
      display_players_stats
      display_grand_winner(grand_winner) if grand_winner
      break unless play_again?
      system 'clear'
    end
  end

  def play
    display_welcome_message
    game_flow
    display_goodbye_message
  end
end

RPSGame.new.play
