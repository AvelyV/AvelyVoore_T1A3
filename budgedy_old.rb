# import gems
require 'json'
require 'tty-prompt'
require 'tty-font'
require 'rainbow'

# prints main menu
def main_menu
  categories = read_json("Categories/cat.json")
  
  quit = false

  while quit == false
    prompt = TTY::Prompt.new
    puts Rainbow(" ###### MAIN MENU ######").darkolivegreen
    input = prompt.select("What would you like to do?",
                          ["New Entry", "Budget Period Overview", "Modify Categories", "Delete an Expense",
                           "Change Limits", "Exit"], cycle: true)
    case input
    when "New Entry"
      # takes user to new expence menu
      new_exp_menu(choose_file)
    when "Budget Period Overview"
      # takes user to Budget overview menu
      begin
        system('clear')
        overview(choose_file)
      rescue StandardError
        puts Rainbow("There are no existing budget periods to display").salmon
      end
    when "Modify Categories"
      back = false
      while back == false
        answer = prompt.select("What would you like to do?", ['Add a category', 'Delete a category', 'Back'],
                               cycle: true)
        case answer
        when "Add a category"
          modify_category(categories) do
            add = prompt.ask('Which category would you like to add?') do |q|
              q.modify :strip, :capitalize
            end
            categories << add
          end
        when "Delete a category"
          modify_category(categories) do
            del = prompt.select('Which category would you like to delete?', categories, per_page: 10, cycle: true)
            categories.delete(del.to_s)
          end
        when "Back"
          back = true
        end
      end
    when "Delete an Expense"
      begin
        file = prompt.select("What period would you like to delete from?", choose_file, per_page: 10, cycle: true)

        json = read_json("periods/#{file}.json")
        choices = json["expenses"].each_with_index.map do |expense, index|
          {
            name: "#{expense['date']}, $#{expense['price']} on #{expense['category']}; Comment: #{expense['comment']}",
            value: index
          }
        end

        p choices

        ex_to_del = prompt.select("Choose an expense to delete: ", choices, cycle: true)
        json["expenses"].delete_at(ex_to_del)

        write_json(json, "periods/#{file}", "Expense Removed")
      rescue StandardError
        puts Rainbow("There are no existing expenses.").salmon
      end
    when "Change Limits"
      begin
        change_limit(choose_file)
      rescue StandardError
        puts Rainbow("There are no existing budget periods. Add at least one to change the limit.").salmon
      end
    when "Exit"
      print_fancy('Goodby')
      quit = true
    end
  end
end

# take user input for new period
def new_period_info
  prompt = TTY::Prompt.new
  b_name = prompt.ask("Give the new budget period a unique name: ") do |q|
    q.validate(/[:word]/, "Invalid period name: \"%{value}\", special characters not allowed.")
    q.required true
    q.modify :trim
  end

  # get file names
  name = file_names(b_name)

  limit = prompt.ask("What is the limit for \"#{name}\" period? $") do |q|
    q.required true
    # convert to float, print an error in case entered value was not numeric
    q.convert(:float, "Error, enter numeric value")
    # checks if entered value is a positive number
    q.validate(/^[+]?([.]\d+|\d+[.]?\d*)$/, "Invalid input, enter positive number.")
  end

  # Storing new period in a hash
  period = { name: name.to_s, limit: limit.to_s, expenses: [] }
  return period
end

# writes the new period into json file
def create_new_period(period)
  JSON.generate(period)
  File.open("./files/periods/#{period[:name]}.json", "w") do |f|
    f.write(period.to_json)
  end
end

# create an array with file names without file extensions
def file_names(b_name)
  array = b_name.chars
  array.map! do |letter|
    letter = '_' if letter == ' '
    letter
  end
  array.join
end


# new expence menu
def new_exp_menu(choose_file)
  back = false
  while back == false
    prompt = TTY::Prompt.new
    inputs = prompt.select("Where would you like to add the expence?",
                           ["Existing Budget Period", "Create New Budget Period", "Back"], cycle: true)
    case inputs
    when "Existing Budget Period"
      begin
        per = prompt.select("Choose a period you would like to add to", choose_file, cycle: true)
        new_expense(per, read_json("Categories/cat.json"))
      rescue StandardError
        puts Rainbow("There are no existing budget periods to add an expense to. Create a new budget period first.").salmon
      end
    when "Create New Budget Period"
      create_new_period(new_period_info)
    when "Back"
      back = true
    end
  end
end

# gets all the filenames w/out file extesions
def choose_file
  period = []
  files =  Dir.children "./files/periods"
  files.map! do |file|
    file = file.split('.').first
    period << file
  end
  return period
end

# adds new expence to a period
def new_expense(period, all_categories)
  puts "Enter new expense details"
  prompt = TTY::Prompt.new

  date = prompt.ask("Date: ") do |q|
    q.required true
    q.convert(:date, "Error, enter date YYYY/MM/DD")
  end

  price = prompt.ask("Price: $") do |q|
    q.required true
    q.convert(:float, "Error, enter a numeric value")
    # checks if entered value is a positive number
    q.validate(/^[+]?([.]\d+|\d+[.]?\d*)$/, "Invalid price value: \"%{value}\", enter positive number.")
  end

  category = prompt.select("Category:", all_categories, cycle: true)

  comment = prompt.ask("Comment: ")

  json = read_json("periods/#{period}.json")
  json["expenses"] << { "date" => date, "price" => price, "category" => category, "comment" => comment }

  write_json(json, "periods/#{period}", "New expense added")
end

# overview of chosen period
def overview(choose_file)

  puts "█▀█ █░█ █▀▀ █▀█ █░█ █ █▀▀ █░█░█"
  puts "█▄█ ▀▄▀ ██▄ █▀▄ ▀▄▀ █ ██▄ ▀▄▀▄▀"
  prompt = TTY::Prompt.new
  inputs = prompt.select("What period would you like to see?", choose_file, per_page: 10, cycle: true)
  json = read_json("periods/#{inputs}.json")
  # prints out period introduction
  puts Rainbow("Period \"#{json['name']}\" limit is $#{json['limit']}").lightblue

  expenses = json["expenses"]
  # calculates the sum of expenses in the period
  sum = calc_sum_of_exp(expenses)
  puts Rainbow("Your total spendings are $#{sum}").lightblue

  limit = json['limit'].to_f.round(2)
  # print out budget status
  limit_status(limit, sum)
  # prints all the expenses
  expenses(sum, expenses)
end

def print_fancy(text)
  font = TTY::Font.new(:doom)
  puts font.write(text)
end

# Checks if there are any expenses
def expenses(sum, expenses)
  if sum == 0
    puts Rainbow("There are no expenses in this period").salmon
  else
    # prints out all the expenses in the period
    print_expenses(expenses)
  end
end

# add all the prices in the period
def calc_sum_of_exp(expenses)
  prices = []
  expenses.each do |num|
    prices << num['price'].to_f
  end
  return prices.inject(0, :+)
end

def limit_status(limit, sum)
  # print out budget status
  if sum <= limit
    puts Rainbow("You are $#{limit - sum} under the budget").lightgreen
  elsif sum > limit
    puts Rainbow("You are $#{(sum - limit).round(2)} over the budget").lightpink
  else
    puts "Something is not right"
  end
end

# called in overview method
def print_expenses(expenses)
  puts "Expenses: "
  # Print all the expenses in chosen period
  expenses.each_with_index do |hash, index|
    puts Rainbow("#{index + 1}. On #{hash['date']} you spent $#{hash['price']}, Category: #{hash['category']}, Comment: #{hash['comment']}").whitesmoke
  end
end

# change limit in given period
def change_limit(choose_file)
  prompt = TTY::Prompt.new
  per = prompt.select("Choose a periods limit would you like to change?", choose_file, cycle: true)
  # accessing the right file
  json = read_json("periods/#{per}.json")
  puts Rainbow("Current limit is $#{json['limit']}").whitesmoke
  new_limit = prompt.ask("Enter new limit: $") do |q|
    q.convert(:float, "Error, enter numeric value")
    q.validate(/^[+]?([.]\d+|\d+[.]?\d*)$/, "Invalid input, enter positive number.")
  end
  # setting the new limit
  json['limit'] = new_limit
  write_json(json, "periods/#{per}", "Limit changed to $#{new_limit}")
end

def read_json(path)
  return JSON.parse(File.read("./files/#{path}"))
end

def write_json(new_json, path, message)
  File.write("./files/#{path}.json", JSON.pretty_generate(new_json))
  puts Rainbow(message).lightblue
end

# adds or removes from categories
def modify_category(categories)
  begin
    puts Rainbow("Current categories: #{categories.join(', ')}").whitesmoke
    yield

    write_json(categories, "Categories/cat", "Available categories are: #{categories.join(', ')}")
  rescue StandardError
    puts "There are no categories to delete"
  end
end
