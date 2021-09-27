
class BudgetPeriod
  attr_accessor :file, :budget_periods, :name, :limit

  require 'csv'
  require 'rainbow'


  @@cat_array = ['Home', 'Food', 'Transport', 'Bills', 'Entertainment', 'Splurge', 'Other']
  @@budget_p = []
  @@budget_periods = {}
  
  def initialize(name, limit)
    @name = name
    @limit = Integer(limit)
    # FIXME: path to files dir not working
    @file = "#{@name.delete(' ')}.csv"
    # array holding budget period names, i don't think i need it
    # @@budget_p << self
    # # FIXME: how to get it to show names instead of object id
    # puts @@budget_p
    # hash holding budget periods
    CSV.open("#{@file}", 'w') do |line|
      line << ['Date', 'Price', 'Category', 'Comment']
    end
    puts Rainbow("New budget period created").lightblue
  end


  
  def self.budget_periods
    @@budget_periods
  end

  # getter for @@budget_p
  def self.budget_p
    @@budget_p
  end

  def self.cat_array
    @@cat_array
  end

  def to_str
    # FIXME: still prints object id
    # I DON'T THINK I NEED THIS
    puts "#{@name} with limit of #{@limit}"
  end

end
