require "tty-prompt"
require 'rainbow'
# require_relative '../classes/budget_period'

# remove items from catArray
def remove_cat(cat_array)
  prompt = TTY::Prompt.new
  del = prompt.select('Which category would you like to delete?', cat_array)

  cat_array.delete(del)
  puts Rainbow("Available categories are: #{cat_array}").whitesmoke
end

# add items to catArray
def add_cat(cat_array)
  prompt = TTY::Prompt.new
  add = prompt.ask('Which category would you like to add?') do |q|
    q.modify :strip, :capitalize
  end
  cat_array << add
  puts Rainbow("Available categories are: #{cat_array}").whitesmoke
end
