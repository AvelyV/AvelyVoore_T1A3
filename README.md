# About  
Budgedy is a simple budgeting app that runs from the terminal.  
It allows you to track your spending and be more financially aware. 


# Installation  
Budgedy can be installed by clicking on the "Code" button at the top of this page. Clone this repository or download it and then unzip. 
In the terminal, first, run ```gem install bundler```. If you already have bundler installed, you can skip this step.   
Then, you are ready to use the application. To do so, run ```./budgedy.sh``` from the terminal.  
If you are not sure how to access terminal on your computer, check out this [article](https://towardsdatascience.com/a-quick-guide-to-using-command-line-terminal-96815b97b955) and read the "opening command line" bit.  



# Using the App
After you have followed the installation steps, you can run the app in your terminal by typing **./budgedy.sh** and hitting enter. 
That will open the application and take you to *main menu*. From here you are able to access everything else. 
![main menu](./files/img/mainmenu.png)  
Main menu is navigated using arrows and pressing enter on the option you'd like to choose.  

To create a new budget period choose the first option, **New Entry**, from main menu, then choose the second option, **Create New Budget Period**. After that you are asked to enter a name (like january 2021 or christmas party for example) and limit for the period. You can do that typing on your keyboard and hitting enter when done. After that, you are taken back to secondary menu, to get back to main menu, choose option *Back*.  

To record an expense, choose **New Entry** from main menu. Them, from secondary menu, choose **Existing Budget Period**. After that, you will see all your budget periods. Choose the one you would like to add an expense to. After that you are asked to input *date*, *price*, choose from *categories* and write a *comment* if you choose to. You should see a confirmation "New expense added" on the screen.  

Next option on the main menu is **Budget Period Overview**. When you choose that, once again you'll be asked to choose a budget period. Then, name and limit for your chosen period will be printed on screen, as well as your total spendings, status, which lets you know if you are over or under the budget and by how much and then, all the entered expenses are diplayd on the screen. You are automatically taken back to main menu.  

To modify categories for the expenses, use the 3rd optionin main menu alles **Modify Categories**. Then you are asked if you'd like to **Add a category** or **Delete a category**.  
If you choose the first option, all the current categories are printed and you are asked to enter a category that you would like to add.  
If you choose to Delete a category, you are asked to choose a category you would like to be deleted.  
Once you have done that you are taken back to secondary menu. To get back to main menu, choose *Back*.  

To remove an entry, choose **Delete an Expense** from the main menu. Then, all the existing budget periods are displayd. Choose the one you would like to delete an expense. Once you have done that, another list is printed with all the entered expenses in that budget period. Use up and down keys to choose the one you'd like to delete. When you hit enter, confirmation "Expense Removed" should be displayd. Takes you automatically back to main menu.

There is also an option the change the limits for existing budget periods. Choose the 5th option, *Change Limits* in main menu. Then, choose a period thats' limit you would like to change. Once you have done that, current limit is printed and  you are asked to enter the new limit. Confirmation "Limit changed..." will be printed on the screen. Takes you automatically back to main menu.   

To exit the aplication, choose **Exit** from the mein menu. All changes are automatically saved.

# Dependancies  
Budgedy is written in Ruby programming language and in order to use it, Ruby needs to be installed on your computer. You can find instructions to do so in [Ruby documentation](https://www.ruby-lang.org/en/downloads/). 

App uses following Ruby gems to run : 

gem "artii", "~> 2.1"

gem "tty-prompt", "~> 0.23.1"

gem "rainbow", "~> 3.0"

gem "rspec", "~> 3.10"

gem "tty-font", "~> 0.5.0"


These are automatically downloaded when you run the app in the terminal using *./budgedy.sh*


# System and Hardware requirements
Budgedy runs on all operating systems. 