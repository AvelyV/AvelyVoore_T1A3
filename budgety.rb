
# prints main menu
def main_menu
  require "tty-prompt"
  main_menu = TTY::Prompt.new

  input = main_menu.select("What would you like to do?", ["New Entry", "Budget Period Overview", "Delete an Entry"])

  if input == "New Entry"
    puts "This is new entry"
  elsif input == "Budget Period Overview"
    puts "This is overview"
  elsif input == "Delete an Entry"
    puts "This is where you delete and entry"
  end
end

main_menu