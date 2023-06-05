PLAYER_MARKER = "X"
COMPUTER_MARKER = "O"
SCORE_TO_WIN = 5
RESET = 0
DEFAULT_MODE = "Easy"

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

def welcome_message
  promt "Welcome to the Tic Tac Toe game!" \
  "\nYou need to win 5 times to become a grand winner" \
  "\nLet's begin!"
end

def prompt_choose_starting_player
  promt "Type 'Yes' to start first or press Enter to start"
  answer = gets.chomp.downcase.gsub(/[' "]/, '').start_with?("y")
  if answer
    return "Player"
  end
  "Computer"
end

def prompt_choose_mode
  promt "Difficulty level of the game: 'Easy'." \
  "\nType 'Hard' to change or press Enter to start"
  answer = gets.chomp.downcase.gsub(/[' "]/, '').start_with?("h")
  if answer
    return "Hard"
  end
  DEFAULT_MODE
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
    message += if !(index == last_index)
                 item.to_s + "#{split} "
               else
                 "#{and_or} " + item.to_s
               end
  end
  message
end

def empty_squares(board)
  board.keys.select { |num| board[num].is_a?(Integer) }
end

def get_center_index(size)
  if size.odd?
    (size**2 + 1) / 2
  else
    (size**2 - size) / 2 + 1
  end
end

def find_at_risk_square(line, board, marker, size)
  if board.values_at(*line).count(marker) == size - 1
    return board.select do |k, v|
      line.include?(k) && v.is_a?(Integer)
    end.keys.first
  end
  nil
end

def computer_places_piece!(board, winner_combinations, size)
  square = nil

  # offense
  winner_combinations.each do |line|
    square = find_at_risk_square(line, board, COMPUTER_MARKER, size)
    break if square
  end

  # defense first
  if !square
    winner_combinations.each do |line|
      square = find_at_risk_square(line, board, PLAYER_MARKER, size)
      break if square
    end
  end

  # prioritize pick
  if !square
    square = find_prioritized_move(board, winner_combinations, size)
  end

  # just pick a square
  if !square
    square = empty_squares(board).sample
  end

  board[square] = COMPUTER_MARKER
end

def find_prioritized_move(board, winner_combinations, size)
  center_index = get_center_index(size)
  prioritized_line = nil
  highest_marked_squares = 0

  winner_combinations.each do |line|
    prioritized_line, highest_marked_squares = update_prioritized_line(
      board, line, center_index, prioritized_line, highest_marked_squares
    )
  end

  get_move_from_prioritized_line(board, center_index,
                                 prioritized_line, highest_marked_squares)
end

def update_prioritized_line(board, line, center_index,
                            prioritized_line, highest_marked_squares)
  if !board.values_at(*line).include?(PLAYER_MARKER)
    marked_squares = board.values_at(*line).count(COMPUTER_MARKER)

    if marked_squares > highest_marked_squares
      highest_marked_squares = marked_squares
      prioritized_line = line
    elsif board[center_index].is_a?(Integer) && highest_marked_squares == 0
      prioritized_line = line
    elsif prioritized_line.nil? && highest_marked_squares == 0
      prioritized_line = line
    end
  end

  return prioritized_line, highest_marked_squares
end

def get_move_from_prioritized_line(board, center_index,
                                   prioritized_line, highest_marked_squares)
  if !prioritized_line.nil? && highest_marked_squares > 0
    prioritized_line.find { |item| board[item].is_a?(Integer) }
  elsif !prioritized_line.nil? && board[center_index].is_a?(Integer)
    center_index
  else
    prioritized_line.find { |item| board[item].is_a?(Integer) }
  end
end

# Promts user to pick a number. Fill the square
def places_piece!(board, current_player, size,
                  winner_combinations, difficulty_level)
  if current_player == "Player"
    availabe_number = joinor(empty_squares(board))
    square = prompt_choose_square(availabe_number, board)
    board[square] = PLAYER_MARKER
  elsif current_player == "Computer"
    if difficulty_level == "Hard"
      # offense_defense(board, size, winner_combinations)
      computer_places_piece!(board, winner_combinations, size)
    else
      square = empty_squares(board).sample
      board[square] = COMPUTER_MARKER
    end
  end
end

# Method asks to enter a valid number and returns the number
def prompt_choose_square(availabe_number, board)
  loop do
    promt "Choose a square: (#{availabe_number})"
    square = gets.chomp.to_i
    if empty_squares(board).include?(square)
      return square
    else
      puts "Sorry this is not valid choice."
    end
  end
end

def initialize_board(size)
  size_in_square = size**2
  (1..size_in_square).zip(1..size_in_square).to_h
end

# Create table by specified size
def display_board(board, scores, difficulty_level)
  size = Math.sqrt(board.size).to_i
  # max_number_length = board.values.max.to_s.length
  max_number_length = board.values.select do |value|
    value.is_a?(Integer)
  end.max.to_s.length

  cell_width = max_number_length + 2
  separator = "+" + "-" * (cell_width + 2)

  system "clear"
  promt "You are a #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}." \
  "The game mode is #{difficulty_level}"
  promt "Player score: #{scores[:player]}, Computer score: #{scores[:computer]}"
  puts ""
  puts separator * (size - 1) + separator + "+"
  index = 1

  (size - 1).downto(0) do |i|
    row = ""
    (size - 1).downto(0) do |_|
      row += format("| %#{cell_width}s ", board[index])
      index += 1
    end
    puts row + "|"
    puts separator * (size - 1) + separator + "+" unless i == 0
  end

  puts separator * (size - 1) + separator + "+"
  puts ""
end

def detect_winner(board, size, winner_combinations)
  winner_combinations.each do |line|
    if board.values_at(*line).count(PLAYER_MARKER) == size
      return "Player"
    elsif board.values_at(*line).count(COMPUTER_MARKER) == size
      return "Computer"
    end
  end
  nil
end

def someone_won?(board, size, winner_combinations)
  !!detect_winner(board, size, winner_combinations)
end

def determine_table_size
  size = nil
  loop do
    msg = "Determine your table size by entering any number from 3 up to 19"
    promt(msg)
    size = gets.chomp.to_i
    if size <= 2 || size > 19
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

# Initialize the game
def start_game(scores)
  # On each interation of 5 games the first_player will begin first
  first_player = prompt_choose_starting_player
  current_player = first_player
  difficulty_level = prompt_choose_mode
  size = determine_table_size
  winner_combinations = generate_winning_combinations(size)

  game_flow(size, scores, difficulty_level, first_player,
            current_player, winner_combinations)
end

# Start the game again or close the game
welcome_message
loop do
  # Track scores
  scores = { player: 0, computer: 0 }
  start_game(scores)
  promt "Play again? (y or n)"
  answer = gets.chomp.downcase.gsub(/[' "]/, '').start_with?("y")
  if answer == false
    break
  end
  system "clear"
end

promt "Thank you for playing Tic Tac Toe!"
