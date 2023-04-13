require 'yaml'
MESSAGES = YAML.load_file('calculator_messages.yml')
MON_IN_YEAR = 12
PERCENTAGE = 100

LANGUAGE = 'en'
current_language = ''
repeat = true

def prompt(key, current_language = LANGUAGE)
  message = MESSAGES[current_language][key]
  Kernel.puts("=> #{message}")
end

def valid?(number)
  number.to_f > 0.0 &&
    (number.to_f.to_s == number || number.to_i.to_s == number)
end

def user_input(message, invalid_input, current_language,
               zero_allowed = true)
  while true
    prompt(message, current_language)
    input = Kernel.gets().chomp()
    if (input.to_f == 0.0 && zero_allowed) || valid?(input)
      break
    end
    prompt(invalid_input, current_language)
  end
  input
end

loop do
  prompt('choose_language')
  current_language = Kernel.gets().chomp().downcase()
  case current_language
  when 'en'
    current_language = 'en'
    break
  when 'es'
    current_language = 'es'
    break
  when 'ru'
    current_language = 'ru'
    break
  end
  prompt('invalid_input', LANGUAGE)
end

system 'clear'

prompt('welcome', current_language)

while repeat
  loan_amount = user_input(
    "loan_amount", "invalid_input", current_language, false
  ).to_f
  apr = user_input(
    "apr", "invalid_input", current_language
  ).to_f
  loan_dur_in_y = user_input(
    "loan_dur_in_y", "invalid_input", current_language
  ).to_i
  # If loan_dur_in_y is 0 then loan_dur_in_mon has to be more than 0
  check_duration = loan_dur_in_y != 0
  loan_dur_in_mon = user_input(
    "loan_dur_in_mon", "invalid_input",
    current_language, check_duration
  ).to_i

  mon_int_rate = (apr / PERCENTAGE) / MON_IN_YEAR
  loan_dur_in_month = loan_dur_in_y * MON_IN_YEAR + loan_dur_in_mon

  if mon_int_rate == 0.0
    mon_pay = loan_amount / loan_dur_in_month
  else
    mon_pay = loan_amount *
              (mon_int_rate / (1 - (1 + mon_int_rate)**(-loan_dur_in_month)))
  end

  total_pay = loan_dur_in_month * mon_pay
  total_int = total_pay - loan_amount
  mon_int_rate_in_per = mon_int_rate * PERCENTAGE

  message = format(
    MESSAGES[current_language]["output"],
    mon_int_rate: mon_int_rate_in_per,
    loan_dur_in_mon: loan_dur_in_month.round(2),
    total_pay: total_pay.round(2),
    mon_pay: mon_pay.round(2),
    total_int: total_int.round(2)
  )
  puts "=> #{message}"

  prompt("repeat", current_language)
  # If input is embedded in double and/or single quotes
  input = Kernel.gets().chomp().downcase().gsub(/[' "]/, '')
  if input == "exit"
    repeat = false
  else
    system 'clear'
  end
end

prompt("thank_you", current_language)
