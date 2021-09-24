require_relative 'classes/budget_period'
require_relative 'modules/user_input'
require_relative 'modules/menus'
require "tty-prompt"

include Menus
include Input

# calling main_menu method in Menus module
Menus.main_menu