require "tty-prompt"

# remove items from catArray
def remove_cat
  catArray = ['Home', 'Food', 'Transport', 'Bills', 'Entertainment', 'Splurge', 'Other']
  d = TTY::Prompt.new
  j = d.select('Which category would you like to delete?', catArray)

  catArray.delete(j)
  pp catArray
end

# add items to catArray
def add_cat
  catArray = ['Home', 'Food', 'Transport', 'Bills', 'Entertainment', 'Splurge', 'Other']
  v = TTY::Prompt.new
  w = v.ask('Which category would you like to add?') do |q|
    q.modify :strip, :capitalize
  end
  catArray << w
  pp catArray
end

remove_cat
add_cat
