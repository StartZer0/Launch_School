# This class will be used to track total score and determine grand winner
class Score
  attr_accessor :score, :score_to_win

  RESET = 0

  def initialize(score_to_win = 3)
    @score_to_win = score_to_win
    @score = 0
  end

  def check_grand_score
    @score == @score_to_win
  end

  def reset
    @score = RESET
  end

  def increment
    @score += 1
  end
end

class Move
  attr_accessor :value, :moves

  def initialize
    @moves = {}
  end

  WIN_CONDITIONS = {
    'rock' => ['lizard', 'scissors'],
    'paper' => ['rock', 'spock'],
    'scissors' => ['paper', 'lizard'],
    'lizard' => ['paper', 'spock'],
    'spock' => ['rock', 'scissors']
  }

  VALUES = WIN_CONDITIONS.keys

  def win_condition(choice)
    WIN_CONDITIONS[value].include?(choice)
  end

  # Push all moves into hash to track players moves
  def track_move(player_name, move)
    @moves[player_name] ||= []
    @moves[player_name].push(move)
  end

  def track_moves(human_move, computer_move, human, computer)
    track_move(human.name, human_move)
    track_move(computer.name, computer_move)
  end
end

module FindWinner
  def human_win?(human_move, computer_move)
    human_move_type = Move.new
    human_move_type.value = human_move
    human_move_type.win_condition(computer_move)
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
    moves.track_moves(human_move, computer_move, human, computer)
  end
end

class Player
  attr_accessor :name, :move, :score

  def initialize
    @score = Score.new
  end
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
      name = gets.chomp.strip
      break unless name.empty?

      puts 'Sorry, you need to enter your name: '
    end
    self.name = name
  end

  def identify_move(choice)
    choices_map = {
      "r" => "rock",
      "p" => "paper",
      "l" => "lizard",
      "sp" => "spock",
      "s" => "scissors"
    }
    choices_map[choice]
  end

  def choose
    choice = nil
    loop do
      puts '=> Please, choose (r)ock, (p)aper, (l)izard, (sp)ock or (s)cissors:'
      choice = gets.chomp.downcase
      choice = identify_move(choice) if choice.size <= 2
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
      return (['scissors'] * 4) + ['rock'] + (['lizard', 'spock'] * 2)
    end
    return ['rock'] if name == 'R2D2'
    Move::VALUES
  end
end

module Displayable
  def choose_number_of_rounds
    answer = ''
    loop do
      puts '=> How many rounds would you like to play?'
      answer = gets.chomp.strip
      break if answer.to_i.to_s == answer && answer.to_i > 0

      puts 'Sorry, you need to enter a valid number higher than 0'
    end
    display_rounds_message(answer)
  end

  def display_rounds_message(answer)
    human.score.score_to_win = answer.to_i
    computer.score.score_to_win = answer.to_i
    puts "Win #{human.score.score_to_win} rounds to become a grand winner"
  end

  def display_welcome_message
    puts "=> Welcome #{human.name} to Rock, Paper, Lizard, Spock, Scissors!"
  end

  def display_choices
    puts "=> #{human.name} chose #{human.move}"
    puts "=> #{computer.name} chose #{computer.move}"
  end

  def display_winner(winner, human, computer)
    case winner
    when :human
      human.score.increment
      puts "=> #{human.name} won this round!"
    when :computer
      computer.score.increment
      puts "=> #{computer.name} won this round!"
    else
      puts "=> It's a tie!"
    end
  end

  def display_score
    puts "=> #{human.name} score: #{human.score.score}"
    puts "=> #{computer.name} score: #{computer.score.score}"
  end

  def display_moves
    moves.moves.each do |player, moves|
      puts "=> #{player} moves: #{moves.join(' ')} "
    end
  end

  def next_round_message(round, duration = 2.5)
    message = "Be Ready for Round #{round}..."
    interval = duration.to_f / message.length

    message.each_char do |char|
      print char
      sleep(interval)
    end

    puts
  end

  def display_players_stats
    display_choices
    display_score
    display_moves
  end

  def display_goodbye_message
    puts 'Thanks for playing Rock, Paper, Lizard, Spock, Scissors. Good bye!'
  end

  def display_grand_winner(player)
    puts "=> #{player.name} is a grand winner!"
    computer.score.reset
    human.score.reset
    moves.moves = {}
  end
end

class RPSGame
  include Displayable
  include FindWinner

  attr_accessor :human, :computer, :moves, :score

  def initialize
    @human = Human.new
    @computer = Computer.new
    @moves = Move.new
    @score = Score.new
  end

  def grand_winner
    return computer if computer.score.check_grand_score
    return human if human.score.check_grand_score
  end

  def round_flow
    human.choose
    computer.choose
    determine_winner(human, computer)
    display_players_stats
  end

  def prepare_next_round(round)
    next_round_message(round)
    system 'clear'
  end

  def check_and_display_grand_winner
    if grand_winner
      display_grand_winner(grand_winner)
      return true
    end
    false
  end

  def game_flow
    round = 1
    loop do
      prepare_next_round(round)
      round_flow
      break if check_and_display_grand_winner
      round += 1
    end
  end

  def play
    display_welcome_message
    choose_number_of_rounds
    game_flow
    display_goodbye_message
  end
end

RPSGame.new.play
