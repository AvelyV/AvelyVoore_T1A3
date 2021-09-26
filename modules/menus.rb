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
        begin
          choose_period
        rescue
          puts Rainbow("There are no existing budget periods").salmon
        end
      when "Modify Categories"
        mod_cat
      when "Delete an Entry"
        # takes user to deletion entry, fist
        # what period, then what entry
        remove_expense_menu
      when "Exit"
        ### FIXME: This does not work properly
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
        per_prompt = TTY::Prompt.new
        # prints all the periods for user to choose from
        per = per_prompt.select("Choose a period you would like to add to", BudgetPeriod.budget_periods.keys)
        new_expense(per)
        Menus.main_menu
      rescue 
        # this works
        puts Rainbow("There are no existing budget periods").salmon
        Menus.main_menu
      end
    when "Create New Budget Period"
      Input.new_period
    end
  end

  def remove_expense_menu

    begin
      prompt = TTY::Prompt.new
      # prints all the periods for user to choose from
      del = prompt.select("Choose a period you would like to remove from", BudgetPeriod.budget_periods.keys)
      del_expense(del)
    # rescue 
    #   puts Rainbow("There are no existing budget periods").salmon
    #   Menus.main_menu
    end
  end

  def del_expense(del)
    prompt = TTY::Prompt.new
    expense = CSV.foreach("#{BudgetPeriod.budget_periods[del].file}") do |row|
       row
    end
    line = prompt.select("Choose an expence to remove", expense)
  end

  def mod_cat
    prompt = TTY::Prompt.new

    answer = prompt.select("What would you like to do?", ['Add a category', 'Delete a category'])
    case answer
    when "Add a category"
      # adds category to array and takes you back to main menu
      add_cat(BudgetPeriod.cat_array)
      Menus.main_menu
    when "Delete a category"
      # deletes category from array and takes you back to main menu
      remove_cat(BudgetPeriod.cat_array)
      Menus.main_menu
    end
  end

  def choose_period
    prompt = TTY::Prompt.new
    period = prompt.select("Choose a period to display:", BudgetPeriod.budget_periods.keys)
    overview(period)
  end

  # prints out budget overview for the chosen period
  # still functionality to choose a period
  def overview(period)
    # prints out 
    puts Rainbow("\"#{BudgetPeriod.budget_periods[period].name}\" limit is $#{BudgetPeriod.budget_periods[period].limit}").lightblue
    # FIXME: figure out how to add all te values in 'price' column
    puts Rainbow("Your total spendings are ???").lightblue
    # FIXME: how do i make bash script find the right file???
    # %x(``csv2md BudgetPeriod.budget_periods[period].file``)

    # , headers: true
    CSV.foreach("#{BudgetPeriod.budget_periods[period].file}") do |row|
      p row
    end
  end

end
