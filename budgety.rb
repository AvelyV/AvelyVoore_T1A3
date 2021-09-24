require_relative 'classes/budget_period'
# prints main menu
def main_menu
  require "tty-prompt"
  main_menu = TTY::Prompt.new

  input = main_menu.select("What would you like to do?", ["New Entry", "Budget Period Overview", "Delete an Entry"])

  case input
  when "New Entry"
    puts "This is new entry"
  when "Budget Period Overview"
    puts "This is overview"
  when "Delete an Entry"
    puts "This is where you delete and entry"
  end
end


def new_period
    require "tty-prompt"

    n = TTY::Prompt.new
    name = n.ask("What would you like to call the new budget period? ") do |q|
        q.required true
    end
    
    m = TTY::Prompt.new
    limit = m.ask("What is the limit for \"#{name}\" period? $") do |q|
        q.required true
        # convert to float, print an error if entered value was not numeric
        q.convert(:float, "Error, enter numeric value")
    end
    BudgetPeriod.new(name, limit)
end

new_period

