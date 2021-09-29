require_relative '../budgedy_new_def'

# method puts a string, so it will return nil

describe 'limit status' do
    it "giver the right limit status" do
    expect(limit_status(100, 50)).to be(nil)
    end
  end
  