# Question 1
# Every object in Ruby has access to a method called object_id, 
# which returns a numerical value that uniquely identifies the object. 
# This method can be used to determine whether two variables are pointing to the same object.

# Take a look at the following code and predict the output:

a = "forty two"
b = "forty two"
c = a

puts a.object_id # 60
puts b.object_id # 80
puts c.object_id # 60

# Answer:
# c assigned to a. Thus, they are poiting to the same object id in the memory but b is poiting to another id. 
# Although values are the same but the objects are muttable.

# Question 2
# Let's take a look at another example with a small difference in the code:

a = 42
b = 42
c = a

puts a.object_id # 60
puts b.object_id # 80
puts c.object_id # 60

# Answer:
# c assigned to a. Thus, they are poiting to the same id the memory.  b is poiting to the same id as well because the objects are immuttable. 
# Thus, all three objects are referencing to the same id in memory which holwds value 42

# Question 3
# Let's call a method, pass two strings as arguments and see how they can be
# treated differently depending on the method invoked on them inside the method definition.
# Study the following code and state what will be displayed...and why:

def tricky_method(string_param_one, string_param_two)
  string_param_one += "rutabaga"
  string_param_two << "rutabaga"
end

string_arg_one = "pumpkins"
string_arg_two = "pumpkins"
tricky_method(string_arg_one, string_arg_two)

#Answer:
puts "String_arg_one looks like this now: #{string_arg_one}" # "pumpkins"
puts "String_arg_two looks like this now: #{string_arg_two}" # "pumpkinsrutabaga"

# String_arg_one looks like this now: pumpkins
# String_arg_two looks like this now: pumpkinsrutabaga

# += operation is re-assignment and creates a new string object and doesn't mutate the object passed as an argument. 
# << operation mutate the object passed as an argument.

# Question 4
# To drive that last one home...let's turn the tables and have the string show a modified output, while the array thwarts the method's efforts to modify the user's version of it.

def tricky_method_two(a_string_param, an_array_param)
  a_string_param << 'rutabaga'
  an_array_param = ['pumpkins', 'rutabaga']
end

my_string = "pumpkins"
my_array = ["pumpkins"]
tricky_method_two(my_string, my_array)

#Answer:
puts "My string looks like this now: #{my_string}" # "pumpkinsrutabaga"
puts "My array looks like this now: #{my_array}" # ["pumpkins"]
# My string looks like this now: pumpkinsrutabaga
# My array looks like this now: ["pumpkins"]

# Question 5
# Depending on a method to modify its arguments can be tricky:

def tricky_method(a_string_param, an_array_param)
  a_string_param += "rutabaga"
  an_array_param << "rutabaga"
end

my_string = "pumpkins"
my_array = ["pumpkins"]
tricky_method(my_string, my_array)

puts "My string looks like this now: #{my_string}"
puts "My array looks like this now: #{my_array}"

# Whether the above "coincidentally" does what we think we wanted depends upon what is going on inside the method.

# How can we change this code to make the result easier to predict and easier for the next programmer to maintain? 
# That is, the resulting method should not mutate either argument, but my_string should be set to 'pumpkinsrutabaga' 
# and my_array should be set to ['pumpkins', 'rutabaga']

# def tricky_method(a_string_param, an_array_param)
#   a_string_param += "rutabaga"
#   an_array_param += "rutabaga"
#   return a_string_param, an_array_param
# end

# my_string, my_array  = tricky_method(my_string, my_array)

# Question 6
# How could the following method be simplified without changing its return value?

def color_valid(color)
  if color == "blue" || color == "green"
    true
  else
    false
  end
end

#Answer
def color_valid(color)
  color == "blue" || color == "green"
end














