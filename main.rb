#Main function
require_relative 'email.rb'
require_relative 'scrape.rb'
class Main

    #The text file that will contain student org info to be emailed
    fileName = "student_org.txt"

    #Need to get scraped data
    s_Data =

    #s_Data will contain the scraped data
    if s_Data
        #Will be used to put the scraped data into a txt file
        File.open(fileName, 'w') do |file|
            #Need to put scrapped data into file
            fileName.puts(s_Data)
        end
    end

    #Passes the student org data to be emailed
    email(student_org.txt)


end
