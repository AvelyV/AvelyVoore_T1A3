require 'csv'

class BudgetPeriod
  @@total_periods = 0
  @@budget_p = []
  
  def initialize(name, limit)
    @name = name
    @limit = Integer(limit)
    @@total_periods += 1
    @@budget_p << self
    @file = "./../files/#{@name}.csv"
    # how can i make a csv file with the period name ???
    CSV.open(@file, 'a') do |line|
      line << ['date', 'price', 'category', 'comment']
    end
  end

  def to_s
    puts "Budget period #{@name} has a limit of $#{@limit} "
  end

end


sept = BudgetPeriod.new('Sept', 1500)

puts aug
puts oct

