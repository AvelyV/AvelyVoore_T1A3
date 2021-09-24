module Input

require 'tty-prompt'


def new_expense
  d = TTY::Prompt.new
  date = d.ask("Date: ") do |q|
    q.required true
    q.convert(:date, "Error, enter date DD/MM/YYYY")
  end
  p = TTY::Prompt.new
    # somehow make them choose from categories
    # insert an array with all the categories
  @file.open do |line|
    line << [date, price, category, comment]
  end
end

  # setting up new budget period
  def new_period

    n = TTY::Prompt.new
    name = n.ask("Give the new budget period a unique name: ") do |q|
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

end
