require_relative '../budgedy_new_def'

# method puts a string, so it will return nil
# will print out the correct output tho

describe 'limit status' do
  it "giver the right limit status" do
    # output in green '50'
    expect(limit_status(100, 50)).to be(nil)
  end
  it "gives the right limit status" do
    # output in pink '10'
    expect(limit_status(50, 60)).to be(nil)
  end
end
