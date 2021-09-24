module NewEntry

require 'tty-prompt'

entry = prompt.collect do
    key(:comment).ask("comment: ")
  
    key(:price).ask("Price: ", convert: :float)

    key(:date).ask("Date: ", convert: :date, value: "DD/MM/YYYY")
  
    key(:category) do
    # somehow make them choose from categories
    # insert an array with all the categories
    end
  end
end
