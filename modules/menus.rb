require "tty-prompt"
require 'rainbow'
require_relative '../classes/budget_period' # need it for new_exp_menu to print existing periods
require_relative 'user_input'
require_relative 'categories'

# module holding all the menus for the app
module Menus
  include Input

  # prints main menu
  def main_menu
    quit = false
    while quit == false
      main_menu = TTY::Prompt.new

      input = main_menu.select("What would you like to do?",
                               ["New Entry", "Budget Period Overview", "Modify Categories", "Delete an Entry", "Exit"])

      case input
      when "New Entry"
        # takes user to new expence menu
        new_exp_menu
      when "Budget Period Overview"
        # takes user to Budget overview menu
        puts "This is overview"
      when "Modify Categories"
        mod_cat
      when "Delete an Entry"
        # takes user to deletion entry, fist
        # what period, then what entry
        puts "This is where you delete and entry"
      when "Exit"
        quit = true
      end
    end
  end

  # adding new expence menu
  def new_exp_menu
    include Input
    m = TTY::Prompt.new
    inputs = m.select("Where would you like to add the expence?",
                      ["Existing Budget Period", "Create New Budget Period"])
    case inputs
    when "Existing Budget Period"
      begin
      k = TTY::Prompt.new

      p = k.select("Choose a period you would like to add to", BudgetPeriod.budget_p)
      rescue 
        # this works
        puts Rainbow("There are no existing budget periods").salmon
        Menus.main_menu
      end
    when "Create New Budget Period"
      # this works until file error
      Input.new_period
    end
  end

  def mod_cat
    # include BudgetPeriod
    k = TTY::Prompt.new

    p = k.select("What would you like to do?", ['Add a category', 'Delete a category'])
    case p
    when "Add a category"
      add_cat(BudgetPeriod.cat_array)
      Menus.main_menu
    when "Delete a category"
      remove_cat(BudgetPeriod.cat_array)
      Menus.main_menu
    end
  end

end
