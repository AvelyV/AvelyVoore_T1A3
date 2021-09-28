require_relative 'budgedy_new_def'

ARGV.each do |argv|
  if argv == '-e' || argv == '--expense'
    # go straight into choosing what period to add the expense to
    choose_file
    new_exp_menu(choose_file)
    main_menu
    new_exp_menu
  elsif argv == '-o' || argv == '--overview'
    # go straight into overview menu
    choose_file
    overview(choose_file)
    main_menu
  else
    main_menu
  end
end

main_menu
