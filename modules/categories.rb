require "tty-prompt"

def remove_cat
  catArray = ['Home', 'Food', 'Transport', 'Bills', 'Entertainment', 'Splurge', 'Other']
  d = TTY::Prompt.new
  j = d.select('Which category would you like to delete?', catArray)

  catArray.delete(j)
  pp catArray
end

remove_cat
