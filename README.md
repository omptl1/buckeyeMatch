This is the readme file for the webscraping program.

Purpose:

The purpose of this program is to help a user narrow down their choices when selecting an organization to join. 
Since there are a large amount of clubs and organizations at OSU it's beneficial to the user to be able to
narrow down their results to make decisions easier. The campus, status, purpose statement, primary leader, 
and primary leader contact information (email) are printed to the console and optionally emailed or saved as 
an HTML file.

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Overview:

The user is presented a list of clubs after entering text to search for. The user then decides how many clubs
from the presented list they would like randomly selected and presented to them. Once the number of organizations
is selected the user will be asked if they would like to receive an email of the options chosen for them or an HTML 
document. If the user responds positively they are asked to enter the email they would like to use. The program 
then sends the user a list of organizations, along with pertinent info, they might be interested in. 

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Instructions:

1. Run the program by typing "ruby webscrape.rb" into the command prompt.
2. When prompted, please enter text to search for on the osu organizations site. The user will receive a list
   of organizations.
3. When prompted, please enter the number of organizations you would like to have randomly selected for you.
   The program will then present the randomly selected organization(s) in the console.
4. When prompted, please respond whether or not you would like to receive an email with this information or
   an HTML document with a hyperlink to quickly email the organization's primary leader.
6. If the user chose to recieve an email they will be prompted to provide the email they would like to use.
7. If the user chose the HTML file an HTML file will be generated for the user to open.
