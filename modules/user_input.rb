require 'tty-prompt'
require_relative '../classes/budget_period'

# module holding all the methods that take user input
module Input

  # adding new expence to a period
  def new_expense(per)
    puts "New expense details"
    prompt = TTY::Prompt.new
    
    date = prompt.ask("Date: ") do |q|
      q.required true
      q.convert(:date, "Error, enter date DD/MM/YYYY")
    end

    price = prompt.ask("Price: $") do |q|
      q.required true
      q.convert(:float, "Error, enter a numeric value")
    end

    category = prompt.select("Choose a category:", BudgetPeriod.cat_array)

    comment = prompt.ask("Comment: ")

    # FIXME: file path
    CSV.open("#{BudgetPeriod.budget_periods[per].file}", 'a') do |line|
      line << [date, price, category, comment]
    end
  end

  # setting up new budget period
  def new_period

    prompt = TTY::Prompt.new
    name = prompt.ask("Give the new budget period a unique name: ") do |q|
      q.required true
    end
    name.delete(' ')

    limit = prompt.ask("What is the limit for \"#{name}\" period? $") do |q|
      q.required true
      # convert to float, print an error if entered value was not numeric
      q.convert(:float, "Error, enter numeric value")
    end
    ###can i store my budget periods in a hash like this?
    BudgetPeriod.budget_periods[name] = BudgetPeriod.new(name, limit)

    puts name
    Menus.main_menu
  end
end
