require "tty-prompt"
require 'rainbow'
require_relative '../classes/budget_period'

# remove items from catArray
def remove_cat(cat_array)
  d = TTY::Prompt.new
  j = d.select('Which category would you like to delete?', cat_array)

  cat_array.delete(j)
  puts Rainbow("Available categories are: #{cat_array}").lavender
end

# add items to catArray
def add_cat(cat_array)
  v = TTY::Prompt.new
  w = v.ask('Which category would you like to add?') do |q|
    q.modify :strip, :capitalize
  end
  cat_array << w
  puts Rainbow("Available categories are: #{cat_array}").lavender
end
