# Import supporting files
require_relative 'budgedy_src'

# If no command line arguments are passed, run main_menu
if !ARGV.any?
  main_menu
else
  ARGV.each do |argv|
    if argv == '-e' || argv == '--expense'
      # go straight into choosing what period to add the expense to
      choose_file
      new_exp_menu(choose_file)
      main_menu
    elsif argv == '-o' || argv == '--overview'
      # go straight into overview menu
      choose_file
      overview(choose_file)
      main_menu
    end
  end
end


