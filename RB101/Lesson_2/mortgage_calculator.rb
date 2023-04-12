require 'yaml'
MESSAGES = YAML.load_file('calculator_messages.yml')

current_language = 'en'
repeat = true

def messages(message, lang=current_language)
  MESSAGES[lang][message]
end

def prompt(key, current_language)
  message = messages(key, current_language)
  Kernel.puts("=> #{message}")
end

def valid?(number)
  number.to_f.to_s == number || number.to_i.to_s == number
end

while repeat
  language = ""
  Kernel.puts("=> Choose language.\nType en: English, es: Spanish, ru: Russian")
  language = Kernel.gets().chomp().downcase()

  if language == 'es'
    current_language = 'es'
  elsif language == 'ru'
    current_language = 'ru'
  end

  loan_amount = ''
  apr = ''
  loan_dur_in_y = ''
  loan_dur_in_m = ''

  prompt('welcome', current_language)

  loop do
    prompt("loan_amount", current_language)
    loan_amount = Kernel.gets().chomp()
    if valid?(loan_amount)
      break
    end
    prompt("valid_number", current_language)
  end

  loop do
    prompt("apr", current_language)
    apr = Kernel.gets().chomp()
    if valid?(apr)
      break
    end
    prompt("valid_number", current_language)
  end

  loop do
    prompt("loan_dur_in_y", current_language)
    loan_dur_in_y = Kernel.gets().chomp()
    if valid?(loan_dur_in_y)
      break
    end
    prompt("valid_number", current_language)
  end

  loop do
    prompt("loan_dur_in_m", current_language)
    loan_dur_in_m = Kernel.gets().chomp()
    if valid?(loan_dur_in_m)
      break
    end
    prompt("valid_number", current_language)
  end

  mo_in_r = (apr.to_f / 100) / 12
  loan_dur_in_m = loan_dur_in_y.to_i * 12 + loan_dur_in_m.to_i
  mo_pay = loan_amount.to_f * (mo_in_r / (1 - (1 + mo_in_r)**(-loan_dur_in_m)))
  total_pay = loan_dur_in_m * mo_pay
  total_in = total_pay - loan_amount.to_f

  message = format(
    MESSAGES[current_language]["output"],
    mo_in_r: mo_in_r,
    loan_dur_in_m: loan_dur_in_m.round(2),
    total_pay: total_pay.round(2),
    mo_pay: mo_pay.round(2),
    total_in: total_in.round(2)
  )
  puts message

  prompt("repeat", current_language)
  input = Kernel.gets().chomp().downcase()
  if input == "exit"
    repeat = false
  end
end

prompt("thank_you", current_language)
