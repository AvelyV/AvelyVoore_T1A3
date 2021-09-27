require 'json'
require 'tty-prompt'
require 'rainbow'

# prints main menu
def main_menu
    quit = false

    while quit == false
      main_menu = TTY::Prompt.new

      input = main_menu.select("What would you like to do?",
                               ["New Entry", "Budget Period Overview", "Modify Categories", "Delete an Entry", "Change Limits", "Exit"])

      case input
      when "New Entry"
        # takes user to new expence menu
        new_exp_menu(choose_file)
      when "Budget Period Overview"
        # takes user to Budget overview menu
        begin
        overview(choose_file)
        # rescue StandardError
        #   puts Rainbow("There are no existing budget periods").salmon
        end
      #DONE:
      when "Modify Categories" 
        mod_cat
      when "Delete an Entry"
        # takes user to deletion entry, fist
        # what period, then what entry
        # FIXME: STILL TO DO
        remove_expense_menu
      when "Change Limits"
        change_limit(choose_file)
      when "Exit"
        quit = true
      end
    end
end




# DONE:
def new_period

  prompt = TTY::Prompt.new
  name = prompt.ask("Give the new budget period a unique name: ") do |q|
    q.required true
  end
  name = name.strip

  limit = prompt.ask("What is the limit for \"#{name}\" period? $") do |q|
    q.required true
    # convert to float, print an error f entered value was not numeric
    q.convert(:float, "Error, enter numeric value")
  end

  # Storing instances in a hash
  period = {name: "#{name}", limit: "#{limit}", expenses: []}
  JSON.generate(period)

  File.open("./files/periods/#{name.delete(' ')}.json", "w") do |f|
    f.write(period.to_json)
  end

end



# DONE: prints all the filenames w/out file extesions
def choose_file
  period = []
  files =  Dir.children "./files/periods"
  files.map! do |file|
    p file = file.split('.').first
    puts "this is file: #{file}"
    period << file
  end
  return period
end


  # DONE:
  # adding new expence menu
  def new_exp_menu(choose_file)

    prompt = TTY::Prompt.new
    inputs = prompt.select("Where would you like to add the expence?",
                           ["Existing Budget Period", "Create New Budget Period"])
    case inputs
    when "Existing Budget Period"
      begin
        per = prompt.select("Choose a period you would like to add to", choose_file)
        new_expense(per, array)
      # rescue StandardError
      #   puts Rainbow("There are no existing budget periods...").salmon
      end
    when "Create New Budget Period"
      new_period
    end
  end
 

  # DONE:
  # adding new expence to a period
  def new_expense(per, array)
    puts "New expense details"
    prompt = TTY::Prompt.new

    date = prompt.ask("Date: ") do |q|
      q.required true
      q.convert(:date, "Error, enter date YYYY/MM/DD")
    end

    price = prompt.ask("Price: $") do |q|
      q.required true
      q.convert(:float, "Error, enter a numeric value")
    end

    category = prompt.select("Choose a category:", array)

    comment = prompt.ask("Comment: ")

    json = JSON.parse(File.read("./files/periods/#{per}.json", symbolize_names: true))

    json["expenses"] << {date: date, price: price, category: category, comment: comment}
    File.write("./files/periods/#{per}.json", JSON.pretty_generate(json))

  end



# DONE:
# parse categories array
def array
  json = JSON.parse(File.read('./files/Categories/cat.json'))
end


# DONE:
def mod_cat
  prompt = TTY::Prompt.new

  answer = prompt.select("What would you like to do?", ['Add a category', 'Delete a category'])
  case answer
  when "Add a category"
    # adds category to array and takes you back to main menu
    add_cat(array)
  when "Delete a category"
    # deletes category from array and takes you back to main menu
    remove_cat(array)
  end
end


# DONE:
# remove items from cat_array
def remove_cat(array)
  prompt = TTY::Prompt.new
  del = prompt.select('Which category would you like to delete?', array)

  # modify array
  array.delete("#{del}")
  # turn array into json
  File.write('./files/Categories/cat.json', JSON.pretty_generate(array))

  puts Rainbow("Available categories are: #{array}").whitesmoke
end



# DONE:
# add items to cat_array
def add_cat(array)
  prompt = TTY::Prompt.new
  add = prompt.ask('Which category would you like to add?') do |q|
    q.modify :strip, :capitalize
  end
    # modify array
    array << add
    # turn array into json
    File.write('./files/Categories/cat.json', JSON.pretty_generate(array))
  puts Rainbow("Available categories are: #{array}").whitesmoke
end



def overview(choose_file)
  system('clear')

  prompt = TTY::Prompt.new
  inputs = prompt.select("What period would you like to see?", choose_file)
  # prints out period introduction
  json = JSON.parse!(File.read("./files/periods/#{inputs}.json"))
  puts Rainbow("Period \"#{json['name']}\" limit is $#{json['limit']}").lightblue

  expenses = json["expenses"]
  expenses.each do |hash|
  puts "On #{hash['date']} you spent $#{hash['price']}, Category: #{hash['category']}, Comment: #{hash['comment']}"
  end


  array = []
  expenses.each do |num|
    array << num['price'].to_f
  end
  sum = array.inject(0, :+)

  puts Rainbow("Your total spendings are #{sum}").lightblue

  if sum <= json['limit'].to_f
    puts Rainbow("You are $#{json['limit'].to_f - sum} under the budget").lightgreen
  elsif sum > json['limit'].to_f
    puts Rainbow("You are $#{json['limit'].to_f} over the budget").lightpink
  else
    puts "Something is not right"
  end

  # FIXME: find a nicer way of printing expenses
  expenses.each do |hash|
    puts "On #{hash['date']} you spent $#{hash['price']}, Category: #{hash['category']}, Comment: #{hash['comment']}"
    end

end


# FIXME: how will you delete an expense
def del_expense

end

# DONE:
def change_limit(choose_file)
  prompt = TTY::Prompt.new
  per = prompt.select("Choose a periods limit would you like to change?", choose_file)

  json = JSON.parse!(File.read("./files/periods/#{per}.json"))
  new_limit = prompt.ask("Enter new limit: $")
  json['limit'] = new_limit
  File.write("./files/periods/#{per}.json", JSON.pretty_generate(json))
end
main_menu