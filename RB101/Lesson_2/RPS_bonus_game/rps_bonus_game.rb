require 'yaml'
MESSAGES = YAML.load_file('rps_bonus_messages.yaml')
SCORE_TO_WIN = 3
RESET = 0

CHOICES = {
  'r' => 'rock',
  'p' => 'paper',
  'sc' => 'scissors',
  'l' => 'lizard',
  'sp' => 'spock'
}
WIN_CONDITION = [['sc', 'p'], ['p', 'r'], ['r', 'l'],
                 ['l', 'sp'], ['sp', 'sc'], ['sc', 'l'],
                 ['l', 'p'], ['p', 'sp'], ['sp', 'r'], ['r', 'sc']]

def prompt(key, **options)
  message = format(MESSAGES[key], **options)
  puts "=> #{message}"
  puts
end

def valid?(string)
  CHOICES.key?(string) || CHOICES.value?(string)
end

def who_won(user_choice, computer_choice)
  if user_choice == computer_choice
    'tie'
  elsif WIN_CONDITION.include?([user_choice, computer_choice])
    'user'
  else
    'computer'
  end
end

def user_choice_display(user_choice)
  if user_choice.length > 2
    if user_choice == 'scissors'
      'sc'
    elsif user_choice == 'spock'
      'sp'
    else
      user_choice[0]
    end
  else
    user_choice
  end
end

system "clear"

prompt('welcome')
prompt('grand_winner_instruction')
sleep(3)
system "clear"
user_score = 0
computer_score = 0
user_choice = ''
grand_winner = ''
repeat = true
while repeat
  loop do
    computer_choice = ['p', 'r', 'sc', 'sp', 'l'].sample()
    loop do
      prompt('choice')
      user_choice = gets.chomp.downcase().gsub(/[' "]/, '')
      break if valid?(user_choice)
      prompt('not_valid')
    end

    result = who_won(user_choice_display(user_choice), computer_choice)

    if result == 'tie'
      prompt('tie')
    elsif result == 'user'
      user_score += 1
      prompt('won', winner: "You", 
                    user_choice: CHOICES[user_choice_display(user_choice)],
                    computer_choice: CHOICES[computer_choice])
    else
      computer_score += 1
      prompt('won', winner: "Computer", 
                    user_choice: CHOICES[user_choice_display(user_choice)],
                    computer_choice: CHOICES[computer_choice])
    end

    prompt('score', user_score: user_score, computer_score: computer_score)

    if user_score == SCORE_TO_WIN
      grand_winner = "you"
      break
    elsif computer_score == SCORE_TO_WIN
      grand_winner = "computer"
      break
    end
    sleep(2)
    system "clear"
  end
  
  prompt('grand_winner', grand_winner: grand_winner)

  prompt('repeat')
  repeat = gets.chomp.downcase().gsub(/[' "]/, '').start_with?('y')
  if repeat
    user_score = computer_score = RESET
  else
    break
  end
  system "clear"
end

prompt('thank_you')
