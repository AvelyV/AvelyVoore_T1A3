require "tty-prompt"
require_relative '../classes/budget_period' # need it for new_exp_menu to print existing periods
require_relative 'user_input'

module Menus
  include Input

  # prints main menu
  def main_menu
    quit = false

    while quit == false
      main_menu = TTY::Prompt.new

      input = main_menu.select("What would you like to do?",
                              ["New Entry", "Budget Period Overview", "Delete an Entry", "Exit"])

      case input
      when "New Entry"
        # takes user to new expence menu
        new_exp_menu
      when "Budget Period Overview"
        puts "This is overview"
      when "Delete an Entry"
        puts "This is where you delete and entry"
      when "Exit"
        quit = true
      end
    end
  end

  # adding new expence menu
  def new_exp_menu
    m = TTY::Prompt.new
    inputs = m.select("Where would you like to add the expence?",
                      ["Existing Budget Period", "Create New Budget Period"])
    case inputs
    when "Existing Budget Period"
      k = TTY::Prompt.new

      p = k.select("Choose a period you would like to add to", BudgetPeriod.budget_p.name)
    when "Create New Budget Period"
      Input.new_period
    end
  end
end
