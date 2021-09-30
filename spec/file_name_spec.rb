require_relative '../budgedy_new_def'

# tests if user input for period name is processed to be 
# turned into a file name

describe 'filename' do
  it "removes 'spaces' from user input" do
    expect(file_names('january 2022')).to eq('january_2022')
  end
  it "removes 'spaces' from user input" do
    expect(file_names('next holiday')).to eq('next_holiday')
  end
end
