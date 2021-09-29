require 'json'
require 'tty-prompt'
require 'rainbow'


# prints main menu
def main_menu
  categories = read_json("Categories/cat.json")
  quit = false

  while quit == false
    prompt = TTY::Prompt.new

    input = prompt.select("What would you like to do?",
                          ["New Entry", "Budget Period Overview", "Modify Categories", "Delete an Entry",
                           "Change Limits", "Exit"], cycle: true)

    case input
    when "New Entry"
      # takes user to new expence menu
      new_exp_menu(choose_file)
    when "Budget Period Overview"
      # leave it as it's own method as you call ot with CLA
      # takes user to Budget overview menu
      begin
        system('clear')
        overview(choose_file)
      # rescue StandardError
      #   puts Rainbow("There are no existing budget periods").salmon
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
    when "Delete an Entry"
      file = prompt.select("What period would you like to delete from?", choose_file, per_page: 10, cycle: true)

      json = read_json("periods/#{file}.json")
      # expenses is an array of expenses hashes
      # FIXME: del wrong stuffff

      choices = json["expenses"].each_with_index.map do |expense, index|
        {
          name: "$#{expense['price']} on #{expense['category']}; #{expense['date']}",
          value: index
        }
      end

      ex_to_del = prompt.select("Choose an expense to delete: ", choices, cycle: true)
      json["expenses"].delete_at(ex_to_del)
      
      message = ""
      write_json(json, "periods/#{file}", message)
      # File.write("./files/periods/#{file}.json", JSON.pretty_generate(json))
    when "Change Limits"
      change_limit(choose_file)
    when "Exit"
      quit = true
    end
  end
end

def new_period_info
  prompt = TTY::Prompt.new
  b_name = prompt.ask("Give the new budget period a unique name: ") do |q|
    q.required true
    q.modify :trim
  end

  array = b_name.split('')
  array.map! do |letter|
    letter = '_' if letter == ' '
    letter
  end
  name = array.join

  limit = prompt.ask("What is the limit for \"#{name}\" period? $") do |q|
    q.required true
    # convert to float, print an error f entered value was not numeric
    q.convert(:float, "Error, enter numeric value")
  end

  # Storing instances in a hash
  period = { name: name.to_s, limit: limit.to_s, expenses: [] }
  return period
end

# DONE:
def create_new_period(period)
  JSON.generate(period)

  File.open("./files/periods/#{period[:name].to_s}.json", "w") do |f|
    f.write(period.to_json)
  end
end

# DONE:
# adding new expence menu
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
        # rescue StandardError
        #   puts Rainbow("There are no existing budget periods...").salmon
      end
    when "Create New Budget Period"
      create_new_period(new_period_info)
    when "Back"
      back = true
    end
  end
end

# DONE: prints all the  filenames w/out file extesions
def choose_file
  period = []
  files =  Dir.children "./files/periods"
  files.map! do |file|
    file = file.split('.').first
    period << file
  end
  return period
end

# DONE:
# adding new expence to a period
def new_expense(per, all_categories)
  puts "Enter new expense details"
  prompt = TTY::Prompt.new

  date = prompt.ask("Date: ") do |q|
    q.required true
    q.convert(:date, "Error, enter date YYYY/MM/DD")
  end

  price = prompt.ask("Price: $") do |q|
    q.required true
    q.convert(:float, "Error, enter a numeric value")
  end

  category = prompt.select("Category:", all_categories, cycle: true)

  comment = prompt.ask("Comment: ")

  json = read_json("periods/#{per}.json")
  json["expenses"] << { "date" => date, "price" => price, "category" => category, "comment" => comment }

  # json = JSON.parse(File.read("./files/periods/#{per}.json", symbolize_names: true))

  # json["expenses"] << { date: date, price: price, category: category, comment: comment }
  message = "New expense added"
  write_json(json, "periods/#{per}", message)
end

def create_new_expense(expense, period)
  json = JSON.parse(File.read("./files/periods/#{period}.json", symbolize_names: true))

  json["expenses"] << expense
  File.write("./files/periods/#{per}.json", JSON.pretty_generate(json))
  puts Rainbow("New expense added").lightblue
end

def overview(choose_file)
  puts Rainbow("█▀▀█ ▀█░█▀ █▀▀ █▀▀█ ▀█░█▀ ░▀░ █▀▀ █░░░█ ").lightblue
  puts Rainbow("█░░█ ░█▄█░ █▀▀ █▄▄▀ ░█▄█░ ▀█▀ █▀▀ █▄█▄█ ").lightgreen
  puts Rainbow("▀▀▀▀ ░░▀░░ ▀▀▀ ▀░▀▀ ░░▀░░ ▀▀▀ ▀▀▀ ░▀░▀░ ").lightpink

  prompt = TTY::Prompt.new
  inputs = prompt.select("What period would you like to see?", choose_file, per_page: 10, cycle: true)
  json = read_json("periods/#{inputs}.json")
  # prints out period introduction
  puts Rainbow("Period \"#{json['name']}\" limit is $#{json['limit']}").lightblue

  expenses = json["expenses"]
  # calculates the sum of expenses in the period
  sum = calc_sum_of_exp(expenses)
  puts Rainbow("Your total spendings are #{sum}").lightblue

  limit = json['limit'].to_f.round(2)
  # print out budget status
  limit_status(limit, sum)
  
  # prints out all the expenses in the period
  print_expenses(expenses)
end

def calc_sum_of_exp(expenses)
  array = []
  expenses.each do |num|
    array << num['price'].to_f
  end
  sum = array.inject(0, :+)
  return sum
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

# called in overview
def print_expenses(expenses)
  puts "Expenses: "
  # FIXME: find a nicer way of printing expenses
  expenses.each_with_index do |hash, index|
    puts Rainbow("#{index + 1}. On #{hash['date']} you spent $#{hash['price']}, Category: #{hash['category']}, Comment: #{hash['comment']}").whitesmoke
  end
end

# FIXME: how will you delete an expense
# choose_file is an array of file names

# DONE:
def change_limit(choose_file)
  prompt = TTY::Prompt.new
  per = prompt.select("Choose a periods limit would you like to change?", choose_file, cycle: true)
  # accessing the right file
  json = read_json("periods/#{per}.json")
  puts Rainbow("Current limit is $#{json['limit']}").whitesmoke
  new_limit = prompt.ask("Enter new limit: $")

  # setting the new limit
  json['limit'] = new_limit
  message = "Limit changed to $#{new_limit}"
  write_json(json, "periods/#{per}", message)
end

def read_json(path)
  return JSON.parse(File.read("./files/#{path}"))
end


def write_json(new_json, path, message)
  File.write("./files/#{path}.json", JSON.pretty_generate(new_json))
  puts Rainbow(message).lightblue
end

def modify_category(categories)
  puts Rainbow("Current categories: #{categories.join(', ')}").whitesmoke
  yield
  message = "Available categories are: #{categories.join(', ')}"
  write_json(categories, "Categories/cat", message)
end