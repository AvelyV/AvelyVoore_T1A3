require_relative '../budgedy_new_def'

# these test pass an array of hashes containing prices
# into the test to see if sum of prices will be correct

describe 'expenses' do
  it "sum of expenses test 1" do
    expect(calc_sum_of_exp([{'price' => 10}, {'price' => 12}, {'price' => 10}])).to be(32.0)
  end
  it "sum of expenses test 2" do
    expect(calc_sum_of_exp([{'price' => 1.0}, {'price' => 19}, {'price' => 20.5}, {'price' => 5.0}])).to be(45.5)
  end
end

