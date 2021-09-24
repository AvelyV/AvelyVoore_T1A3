

class BudgetPeriod
  attr_reader :bedget_p
  require 'csv'

  @@cat_array = ['Home', 'Food', 'Transport', 'Bills', 'Entertainment', 'Splurge', 'Other']
  @@total_periods = 0
  @@budget_p = []
  
  def initialize(name, limit)
    @name = name
    @limit = Integer(limit)
    @@total_periods += 1
    @@budget_p << self
    @file = "./../files/#{@name.delete(' ')}.csv"
    pp @@budget_p
    CSV.open("#{@file}", 'a') do |line|
      line << ['date', 'price', 'category', 'comment']
    end
  end

  # getter for @@budget_p
  def self.budget_p
    @@budget_p
  end

  def self.cat_array
    @@cat_array
  end

  def to_s
    puts "Budget period #{@name} has a limit of $#{@limit} "
  end

end


# sept = BudgetPeriod.new('Sept', 1500)

# puts aug
# puts oct

