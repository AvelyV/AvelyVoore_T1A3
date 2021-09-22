require "tty-prompt"

main_menu = TTY::Prompt.new

main_menu.select("What would you like to do?", %w(New\ entry Monthly\ Overview Delete\ an\ entry))
main_menu_input = gets

if main_menu_input == "New entry"
    puts "Yesssssss"
end