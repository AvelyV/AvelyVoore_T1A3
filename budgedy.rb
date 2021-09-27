# require_relative 'classes/budget_period'
# require_relative 'modules/user_input'
# require_relative 'modules/menus'
# require "tty-prompt"

# include Menus
# include Input
require "json"
# budget_periods = []

puts Dir.children "./files/"

puts "what period?"
input = gets.chomp

json = JSON.parse!(File.read("./files/christmas.json"))

# gets you the limit for the period
limit = json["limit"]
p limit

# gets all the dates and prices for the file
expenses = json["expenses"]
expenses.each do |hash|
  puts "on #{hash['date']} you spent #{hash['price']}"
end



# FIXME: THIS IS GREAT FOR OVERVIEW
sum = 0
expenses.each do |hash|
    sum = sum + hash["price"].to_f
  end
puts sum


# until input_valid == true

# end

### FIXME: How to use ARGV with shell script????
# ARGV.each do |argv|
#   if argv == '-e' || argv == '--expense'
#     # go straight into choosing what period to add the expense to
#     new_exp_menu
#   elsif argv == '-o' || argv == '--overview'
#     # go straight into overview menu
#     puts "argv -o"
#   else
# calling main_menu method in Menus module
# Menus.main_menu
#   end
# end
