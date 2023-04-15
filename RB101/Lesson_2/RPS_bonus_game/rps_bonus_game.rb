require 'yaml'
MESSAGES = YAML.load_file('rps_bonus_messages.yaml')

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
end

def valid?(string)
  CHOICES.key?(string)
end

def win?(user_choice, computer_choice)
  if user_choice == computer_choice
    'tie'
  elsif WIN_CONDITION.include?([user_choice, computer_choice])
    'user'
  else
    'computer'
  end
end

prompt('welcome')

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
      user_choice = gets.chomp.downcase()
      break if valid?(user_choice)
      prompt('not_valid')
    end

    result = win?(user_choice, computer_choice)

    if result == 'tie'
      prompt('tie')
    elsif result == 'user'
      user_score += 1
      prompt('won', winner: "You", user_choice: CHOICES[user_choice],
                    computer_choice: CHOICES[computer_choice])
    else
      computer_score += 1
      prompt('won', winner: "Computer", user_choice: CHOICES[user_choice],
                    computer_choice: CHOICES[computer_choice])
    end

    prompt('score', user_score: user_score, computer_score: computer_score)

    if user_score == 3
      grand_winner = "you"
      break
    elsif computer_score == 3
      grand_winner = "computer"
      break
    end
  end

  prompt('grand_winner', grand_winner: grand_winner)

  prompt('repeat')
  repeat = gets.chomp.downcase().gsub(/[' "]/, '').start_with?('y')
  if repeat
    user_score = computer_score = 0
  else
    break
  end
  system "clear"
end

prompt('thank_you')
