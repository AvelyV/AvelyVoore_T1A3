require_relative 'classes/budget_period'
require_relative 'modules/user_input'
require_relative 'modules/menus'
require "tty-prompt"

include Menus
include Input


# ARGV.each do |argv|
#   if argv == '-e' || argv == '--expense'
#     # go straight into choosing what period to add the expense to
#     new_exp_menu
#   elsif argv == '-o' || argv == '--overview'
#     # go straight into overview menu
#     puts "argv -o"
#   else
    # calling main_menu method in Menus module
    Menus.main_menu
#   end
# end