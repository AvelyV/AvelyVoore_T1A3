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
        rescue StandardError
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
    prompt = TTY::Prompt.new
    inputs = prompt.select("Where would you like to add the expence?",
                           ["Existing Budget Period", "Create New Budget Period"])
    case inputs
    when "Existing Budget Period"
      begin
        # prints all the periods for user to choose from
        per = prompt.select("Choose a period you would like to add to", BudgetPeriod.budget_periods.keys)
        new_expense(per)
        # Menus.main_menu
      rescue StandardError
        # this works
        puts Rainbow("There are no existing budget periods...").salmon
      end
    when "Create New Budget Period"
      Input.new_period
    end
  end

  def remove_expense_menu
    prompt = TTY::Prompt.new
    # prints all the periods for user to choose from
    del = prompt.select("Choose a period you would like to remove from", BudgetPeriod.budget_periods.keys)
    del_expense(del)
  rescue StandardError
    puts Rainbow("There are no existing budget periods").salmon
    Menus.main_menu
  end

  def del_expense(del)
    prompt = TTY::Prompt.new
    # FIXME: shows some random shit
    expense = CSV.foreach(BudgetPeriod.budget_periods[del].file.to_s) do |row|
      p row
    end
    line = prompt.select("Choose an expence to remove", expense)
    # FIXME: somehow delete the enrty
  end

  def mod_cat
    prompt = TTY::Prompt.new

    answer = prompt.select("What would you like to do?", ['Add a category', 'Delete a category'])
    case answer
    when "Add a category"
      # adds category to array and takes you back to main menu
      add_cat(BudgetPeriod.cat_array)
    when "Delete a category"
      # deletes category from array and takes you back to main menu
      remove_cat(BudgetPeriod.cat_array)
    end
  end

  def choose_period
    prompt = TTY::Prompt.new
    period = prompt.select("Choose a period to display overview of:", BudgetPeriod.budget_periods.keys)
    overview(period)
  end

  # prints out budget overview for the chosen period
  def overview(period)
    system('clear')
    # prints out period introduction
    puts Rainbow("Period \"#{BudgetPeriod.budget_periods[period].name}\" limit is $#{BudgetPeriod.budget_periods[period].limit}").lightblue

    # creates an array with all the prices in the instances csv file
    array = []

    puts "-------------------------------"
    puts BudgetPeriod.budget_periods
    system "pwd"
    system "csv2md #{BudgetPeriod.budget_periods[period].file}"
    puts "-------------------------------"
    CSV.foreach(BudgetPeriod.budget_periods[period].file.to_s, headers: true, header_converters: :symbol) do |row|
      array << row[:price].to_f
    end
    sum = array.inject(0, :+)

    puts Rainbow("Your total spendings are #{sum}").lightblue
    # FIXME: how do i make bash script find the right file???
    # %x(`csv2md dets21.csv`)

    if sum <= BudgetPeriod.budget_periods[period].limit
      puts Rainbow("You are $#{BudgetPeriod.budget_periods[period].limit - sum} under the budget").lightgreen
    elsif sum > BudgetPeriod.budget_periods[period].limit
      puts Rainbow("You are $#{sum - BudgetPeriod.budget_periods[period].limit} over the budget").lightpink
    else
      puts "Something is not right"
    end

    #   count the lines in the csv file
    line_count = 0
    # FIXME: does not find the file
    CSV.open(BudgetPeriod.budget_periods[period].to_s) do |_line|
      line_count += 1
    end

    if line_count <= 1
      puts "There are no expenses in the period"
    else
      puts Rainbow("List of spendings in \"#{BudgetPeriod.budget_periods[period].name}\":").whitesmoke
      # prints out the list, want to use csv2md
      CSV.foreach(BudgetPeriod.budget_periods[period].file.to_s, headers: true) do |row|
        p row
      end
    end
  end
end
