# 1. Question 1
# What would you expect the code below to print out?
# numbers = [1, 2, 2, 3]
# numbers.uniq
# puts numbers

#Answer:
#uniq method is not destructive without `!`. As a result, the method will return modified array but original array will be unchanged.
# =>1
#   2
#   2
#   3

# Question 2
# Describe the difference between ! and ? in Ruby. And explain what would happen in the following scenarios:

# what is != and where should you use it?
# put ! before something, like !user_name
# put ! after something, like words.uniq!
# put ? before something
# put ? after something
# put !! before something, like !!user_name

# Question 3
# Replace the word "important" with "urgent" in this string:

#A
advice = "Few things in life are as important as house training your pet dinosaur."
advice.gsub!("important", "urgent")
p advice

# Question 4
# The Ruby Array class has several methods for removing items from the array. Two of them have very similar names. Let's see how they differ:

numbers = [1, 2, 3, 4, 5]
# What do the following method calls do (assume we reset numbers to the original array between method calls)?

#A:
numbers.delete_at(1) #deletes element at the given index in array. Output => [1, 3, 4, 5]
numbers.delete(1) #deletes all elements that is equal to the given object in the array. Output => [2, 3, 4, 5]

# Question 5
# Programmatically determine if 42 lies between 10 and 100.

#A:
p (10..100).include?(42)

# Question 6
# Starting with the string:

famous_words = "seven years ago..."
# show two different ways to put the expected "Four score and " in front of it.
#A:
p "Four score and " + famous_words 
p "Four score and " << famous_words 

# Question 7
# If we build an array like this:

flintstones = ["Fred", "Wilma"]
flintstones << ["Barney", "Betty"]
flintstones << ["BamBam", "Pebbles"]

#We will end up with this "nested" array:
#["Fred", "Wilma", ["Barney", "Betty"], ["BamBam", "Pebbles"]]
#Make this into an un-nested array.

#A
# To turn nested array in one-dimensional will mmay use flatten method
# p flintstones.flatten!
# We also can add new element in array with + instead of << at he begining to get the same result as flintstones.flatten!
flintstones = ["Fred", "Wilma"]
flintstones += ["Barney", "Betty"]
flintstones += ["BamBam", "Pebbles"]

# Question 8
# Given the hash below
flintstones = { "Fred" => 0, "Wilma" => 1, "Barney" => 2, "Betty" => 3, "BamBam" => 4, "Pebbles" => 5 }
#Create an array containing only two elements: Barney's name and Barney's number.
#A
# method `select` returns key-value pairs that evaluate to true.
array = flintstones.select { |k, v| k == "Barney"}.to_a.flatten
p array
