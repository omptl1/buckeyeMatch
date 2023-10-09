require 'mechanize'
require 'nokogiri'
require_relative 'mail.rb'

class Main

# Initialize Mechanize
agent = Mechanize.new

# Define the URL of the student organization website
url = 'https://activities.osu.edu/involvement/student_organizations/find_a_student_org'

# Prompt the user for search input
print 'Enter your search query: '
search_query = gets.chomp
query_param = "?v=list&s=#{search_query}&c=Columbus"

# Construct the full URL with the user's query
full_url = url + query_param

# Use the agent to fetch the page
page = agent.get(full_url)

# Parse the fetched page with Nokogiri
doc = page.parser

# Check if no organizations are returned.
if doc.content.include?("No Student Organizations found.")
	abort("Invalid search. No organization found for'#{search_query}'.")
end


# Grab text for each organization and place in map
organization_data = doc.xpath('//strong/a/text()').map do |header|
  {	
    name: header.text.strip,
    id: doc.at_css('body')['id']
  }
end

# Iterate over org data to make list more presentable
organization_data.each_with_index do |org, index|
  puts "#{index + 1}. #{org[:name]}"
end

# Prompt user to choose a club
#puts "\n Please enter the number of the club you are interested in."
#choice = gets.chomp.to_i

#Ask for number of orgs to send in email
puts "\n How many organizations would you like to learn more about?"
numOrgs = gets.chomp.to_i

  for i in 1..numOrgs
    #Make a random number between 0 and org data size
    random_org_index = rand(organization_data.size)

    # Ensure valid input, if invalid program ends
    if random_org_index >= 1 && random_org_index <= organization_data.size
      chosen_org = organization_data[random_org_index]
      org_id = chosen_org[:id] # Ensure you've extracted the ID correctly above

      details_url = "https://activities.osu.edu/involvement/student_organizations/find_a_student_org?i=#{org_id}&v=list&s=#{search_query}&c=Columbus&page=0"
    #else
      #abort("You need to enter a valid number between 0 and #{organization_data.size}")
    end

    # Grabbing the url of the chosen organization
    chosen_Link = doc.xpath("//strong/a/@href")

    # Setting orgLink to the activities main site to later append
    # the chosen_Link to
    orgLink = "https://activities.osu.edu"
    finalLink = orgLink.chomp + chosen_Link[random_org_index]

    # Creating new Mechanize object
    orgAgent = Mechanize.new

    # Creating HTML page for chosen organization
    orgPage = orgAgent.get(finalLink)

    # Creating document parser
    orgDoc = orgPage.parser

    orgData = orgDoc.xpath("//td/text()")

    td_element = doc.at('/table/tbody/tr[4]/td/a/text()')

    #Scrape organization name
    orgName = "#{organization_data[random_org_index][:name]}"

    #Get primary leader name and hyperlinked email
    email = orgDoc.at("th:contains('Primary Leader:') + td a")['href'].sub('mailto:', '')
    orgLead = orgDoc.at("th:contains('Primary Leader:') + td a").text

    puts "\n The organization name is: #{orgName}"
    puts "\n The organization campus is: #{orgData[0]}"
    puts "\n The organization status is: #{orgData[1]}"
    puts "\n The organization purpose stamement is: #{orgData[2]}"
    puts "\n The Primary leader is: #{orgLead}"
    puts "\n The primary leader's email is: #{email}"
    puts "\n\n-------------------------------------------------------------------------------\n\n"
    
    #Output file name
    fileName = "student_org.txt"

    #Will be used to put the scraped data into a txt file
    File.open(fileName, 'a') do |file|
      #Need to put scrapped data into file
      file.write("\n The organization name is: #{orgName}")
      file.write("\n The organization campus is: #{orgData[0]}")
      file.write("\n The organization status is: #{orgData[1]}")
      file.write("\n The organization purpose stamement is: #{orgData[2]}")
      file.write("\n The Primary leader is: #{orgLead}")
      file.write("\n The primary leader's email is: #{email}")
      file.write("\n\n-------------------------------------------------------------------------------\n\n")

    end
  end
 


  #Passes the student org data to be emailed
  send = SendEmail.new
  send.email(fileName)

  #This is used to clear the file after sending recommendations
  File.open(fileName, 'w') do |file| end

end
