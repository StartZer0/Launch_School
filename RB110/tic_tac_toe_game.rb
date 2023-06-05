INITIAL_MARKER = " "
PLAYER_MARKER = "X"
COMPUTER_MARKER = "O"
SCORE_TO_WIN = 5
RESET = 0

# Generates arrays of winning combinations for the specified size of the table
def generate_winning_combinations(size)
  winning_combinations = []

  winning_combinations += generate_row_combinations(size)
  winning_combinations += generate_column_combinations(size)
  winning_combinations += generate_diagonal_combinations(size)

  winning_combinations
end

def generate_row_combinations(size)
  (1..size).map { |row| (1..size).map { |col| (row - 1) * size + col } }
end

def generate_column_combinations(size)
  (1..size).map { |col| (1..size).map { |row| (row - 1) * size + col } }
end

def generate_diagonal_combinations(size)
  diagonals = []
  diagonal1 = (1..size).map { |i| (i - 1) * size + i }
  diagonal2 = (1..size).map { |i| (i - 1) * size + size - i + 1 }
  diagonals << diagonal1 << diagonal2
end

def who_goes_first
  promt "Do you want to start first? Enter: Yes or No"
  answer = gets.chomp.downcase().gsub(/[' "]/, '').start_with?("y")
  if answer
    return "Player"
  end
  "Computer"
end

def choose_mode
  promt "Choose difficulty level of the game. Enter: Easy or Hard"
  answer = gets.chomp.downcase().gsub(/[' "]/, '').start_with?("h")
  if answer
    return "Hard"
  end
  "Easy"
end

def promt(msg)
  puts "=> #{msg}"
end

# Joins the availabe numbers to pick
def joinor(arr, split = "", and_or = "or")
  message = ""
  last_index = arr.length - 1
  return arr[0] if arr.size == 1

  split = "," if arr.length > 2 && split == ""
  arr.each_with_index do |item, index|
    if !(index == last_index)
      message += item.to_s + "#{split} "
    else
      message += "#{and_or} " + item.to_s
    end
  end
  message
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

# Hard mode
def offense_defense(brd, size, winner_combinations)
  # Get the center index based on the board size
  center_index = get_center_index(size)

  # Pick center square of the table to increase chances to win
  if brd[center_index] == INITIAL_MARKER
    return brd[center_index] = COMPUTER_MARKER
  end

  # The highest priority options:
  # Find and mark the square if one square left to win
  # Or prevent player to win.
  winning_move = find_winning_move(brd, winner_combinations, size)
  return brd[winning_move] = COMPUTER_MARKER if winning_move

  # Find the most prioritized line and mark the square
  prioritized_move = find_prioritized_move(brd, winner_combinations, size)
  return brd[prioritized_move] = COMPUTER_MARKER if prioritized_move

  # If none of the conditions above are met, pick a random empty square
  square = empty_squares(brd).sample
  brd[square] = COMPUTER_MARKER
end

def get_center_index(size)
  if size.odd?
    (size**2 + 1) / 2
  else
    (size**2 - size) / 2 + 1
  end
end

def find_winning_move(brd, winner_combinations, size)
  winner_combinations.each do |line|
    # Find and mark the square if one square left to win OR.
    if (brd.values_at(*line).count(COMPUTER_MARKER) == size - 1 &&
       !brd.values_at(*line).include?(PLAYER_MARKER)) ||
       # prevent player to win
       brd.values_at(*line).count(PLAYER_MARKER) == size - 1
      return line.find { |item| brd[item] == INITIAL_MARKER }
    end
  end
  nil
end

def find_prioritized_move(brd, winner_combinations, size)
  center_index = get_center_index(size)
  prioritized_line = nil
  highest_marked_squares = 0

  winner_combinations.each do |line|
    if !brd.values_at(*line).include?(PLAYER_MARKER)
      marked_squares = brd.values_at(*line).count(COMPUTER_MARKER)
      if marked_squares > highest_marked_squares
        highest_marked_squares = marked_squares
        prioritized_line = line
      elsif marked_squares == 0 && brd[center_index] == INITIAL_MARKER &&
            prioritized_line.nil?
        prioritized_line = line
      elsif prioritized_line.nil?
        prioritized_line = line
      end
    end
  end

  if !prioritized_line.nil?
    prioritized_line.find { |item| brd[item] == INITIAL_MARKER }
  end
end

# Promts user to pick a number. Fill the square
def places_piece!(brd, current_player, size,
                  winner_combinations, difficulty_level)
  if current_player == "Player"
    availabe_number = joinor(empty_squares(brd))
    square = pick_square(availabe_number, brd)
    brd[square] = PLAYER_MARKER
  elsif current_player == "Computer"
    if difficulty_level == "Hard"
      offense_defense(brd, size, winner_combinations)
    else
      square = empty_squares(brd).sample
      brd[square] = COMPUTER_MARKER
    end
  end
end

# Method asks to enter a valid number and returns the number
def pick_square(availabe_number, brd)
  loop do
    promt "Choose a square: (#{availabe_number})"
    square = gets.chomp.to_i
    if empty_squares(brd).include?(square)
      return square
    else
      puts "Sorry this is not valid choice."
    end
  end
end

# Creates a hash by specified size
def initialize_board(size)
  size_in_square = size**2
  (1..size_in_square).zip([INITIAL_MARKER] * size_in_square).to_h
end

# Create table by specified size
def display_board(brd, scores, difficulty_level)
  size = Math.sqrt(brd.size).to_i
  system "clear"
  promt "You are a #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}." \
  "The game mode is #{difficulty_level}"
  promt "Player score: #{scores[:player]}, Computer score: #{scores[:computer]}"
  puts ""
  puts "+-----" * (size - 1) + "+-----+"
  index = 1

  (size - 1).downto(0) do |i|
    row = ""
    (size - 1).downto(0) do |_|
      row += "|  #{brd[index]}  "
      index += 1
    end
    puts row + "|"
    puts "+-----" * (size - 1) + "+-----+" unless i == 0
  end

  puts "+-----" * (size - 1) + "+-----+"
  puts ""
end

def detect_winner(brd, size, winner_combinations)
  winner_combinations.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == size
      return "Player"
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == size
      return "Computer"
    end
  end
  nil
end

def someone_won?(brd, size, winner_combinations)
  !!detect_winner(brd, size, winner_combinations)
end

def determine_table_size
  size = nil
  loop do
    msg = "Determine your table size by entering any number above 2"
    promt(msg)
    size = gets.chomp.to_i
    if size <= 2
      puts "This is invalid size"
    else
      return size
    end
  end
end

def alternate_player(current_player)
  if current_player == "Player"
    return "Computer"
  end
  "Player"
end

def check_winner(board, size, winner_combinations, scores)
  if someone_won?(board, size, winner_combinations)
    winner = detect_winner(board, size, winner_combinations)
    if winner == "Player"
      scores[:player] += 1
      promt "#{winner} won!"
    elsif winner == "Computer"
      scores[:computer] += 1
      promt "#{winner} won!"
    end
  else
    promt "It's a tie!"
  end
end

def check_grand_winner(scores)
  promt "Player score: #{scores[:player]}, " \
  "Computer score: #{scores[:computer]}"

  if scores[:player] > scores[:computer]
    promt "Player is a grand winner!"
  else
    promt "Computer is a grand winner!"
  end
  scores[:player] = RESET
  scores[:computer] = RESET
end

def game_flow(size, scores, difficulty_level, first_player,
              current_player, winner_combinations)
  loop do
    board = initialize_board(size)

    loop do
      display_board(board, scores, difficulty_level)
      places_piece!(board, current_player, size, winner_combinations,
                    difficulty_level)
      current_player = alternate_player(current_player)
      break if someone_won?(board, size, winner_combinations) ||
               empty_squares(board).empty?
    end

    display_board(board, scores, difficulty_level)
    check_winner(board, size, winner_combinations, scores)
    sleep(1)
    current_player = first_player

    if scores[:player] == SCORE_TO_WIN || scores[:computer] == SCORE_TO_WIN
      check_grand_winner(scores)
      break
    end
  end
end

# Track scores
scores = { player: 0, computer: 0 }

# Initialize the game
def start_game(scores)
  # On each interation of 5 games the first_player will begin first
  first_player = who_goes_first
  current_player = first_player
  difficulty_level = choose_mode
  size = determine_table_size
  winner_combinations = generate_winning_combinations(size)

  game_flow(size, scores, difficulty_level, first_player,
            current_player, winner_combinations)
end

# Start the game again or close the game
loop do
  start_game(scores)
  promt "Play again? (y or n)"
  answer = gets.chomp.downcase().gsub(/[' "]/, '').start_with?("y")
  if answer == false
    break
  end
end

promt "Thank you for playing Tic Tac Toe!"
