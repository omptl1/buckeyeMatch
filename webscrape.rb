require 'mechanize'
require 'nokogiri'
require_relative 'mail.rb'


class Main

  # Initialize Mechanize
  agent = Mechanize.new

  # Create an HTML string to store organization information
  html_string = "<html><body>"

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

  # Ask for the number of organizations to learn more about
  puts "\n How many organizations would you like to learn more about?"
  numOrgs = gets.chomp.to_i

  #Check for proper input
  while numOrgs > organization_data.size || numOrgs < 1
      # Ask for the number of organizations to learn more about
      puts "\n Please enter a number between 1 and total number of organizations.\n"
      numOrgs = gets.chomp.to_i
  end

  # Create arrays to store all the organization information
  orgNames = []
  orgLeaders = []
  orgLinks = []
  orgLeaderEmails = []
  orgs = []
  require 'set'
  randomNumbers = Set.new
  while orgs.size < numOrgs && orgs.size < organization_data.size
    random_org_index = rand(organization_data.size)

  # If this index hasn't been chosen before, select the organization
    unless randomNumbers.include?(random_org_index)
      randomNumbers.add(random_org_index) # Add the index to our set
      chosen_org = organization_data[random_org_index]
      orgs.push(chosen_org)
  


# Now, 'orgs' contains the randomly selected unique organizations. You can proceed to use it.

orgs.each do |org|
  org_id = org[:id]

  

      details_url = "https://activities.osu.edu/involvement/student_organizations/find_a_student_org?i=#{org_id}&v=list&s=#{search_query}&c=Columbus&page=0"

      # Grabbing the URL of the chosen organization
      chosen_Link = doc.xpath("//strong/a/@href")

      # Setting orgLink to the activities main site to later append the chosen_Link to
      orgLink = "https://activities.osu.edu"
      finalLink = orgLink.chomp + chosen_Link[random_org_index]  # Move this line inside the loop
      orgLinks.push(orgLink.chomp + chosen_Link[random_org_index])

      # Creating new Mechanize object
      orgAgent = Mechanize.new

      # Creating HTML page for the chosen organization
      orgPage = orgAgent.get(finalLink)

      # Creating document parser
      orgDoc = orgPage.parser

      orgData = orgDoc.xpath("//td/text()")

      # Scrape organization name
      orgNames.push(organization_data[random_org_index][:name])

      # Get primary leader name and hyperlinked email
      email = orgDoc.at("th:contains('Primary Leader:') + td a")['href'].sub('mailto:', '')
      orgLeaderEmails.push(email)
      
      orgLead = orgDoc.at("th:contains('Primary Leader:') + td a").text
      orgLeaders.push(orgLead)

      # Output organization information
      puts "\n The organization name is: #{orgNames.last}"
      puts "\n The organization campus is: #{orgData[0]}"
      puts "\n The organization status is: #{orgData[1]}"
      puts "\n The organization purpose statement is: #{orgData[2]}"
      puts "\n The Primary leader is: #{orgLead}"
      puts "\n The primary leader's email is: #{email}"
      puts "\n\n-------------------------------------------------------------------------------\n\n"

      # Output to file
      fileName = "student_org.txt"
      File.open(fileName, 'a') do |file|
        file.write("\n The organization name is: #{orgNames.last}")
        file.write("\n The organization campus is: #{orgData[0]}")
        file.write("\n The organization status is: #{orgData[1]}")
        file.write("\n The organization purpose statement is: #{orgData[2]}")
        file.write("\n The Primary leader is: #{orgLead}")
        file.write("\n The primary leader's email is: #{email}")
        file.write("\n\n-------------------------------------------------------------------------------\n\n")
      end

      # Append organization details to the HTML string
      html_string += "<h2>Organization Name: #{orgNames.last}</h2>"
      html_string += "<p>Campus: #{orgData[0]}</p>"
      html_string += "<p>Status: #{orgData[1]}</p>"
      html_string += "<p>Purpose Statement: #{orgData[2]}</p>"
      html_string += "<p>Primary Leader: #{orgLead}</p>"
      html_string += "<p>Primary Leader's Email: <a href='mailto:#{email}'>#{email}</a></p>"
      # Assuming email is the student leader's email
      html_string += "<p><a href='contact_form.html?email=#{email}'>Contact Student Leader</a></p>"

      html_string += "<hr>"
      html_string += "\n\n-------------------------------------------------------------------------------\n\n"

    end
  end
end
  # Close the HTML string
  html_string += "</body></html>"

  #Get form of delivery
  puts "\n How would you like to recieve the organization information?"
  puts "\n 1: HTML Format: Includes hyperlinks to student organization leaders!"
  puts "\n 2: Email: Recieve an email with organization information directly in your inbox!"
  userDelivery = gets.chomp.to_i

  #Validate user input
  if(userDelivery != 1 && userDelivery != 2)
    puts "\n Please choose option 1 or 2."
    userDelivery = gets.chomp.to_i
  end

  if userDelivery == 1
    # Write the HTML document to the file
    File.open('output.html', 'w') do |file|
      file.write(html_string)
    end
    puts "The HTML file has been written. It is in the current directory and you can open it with any file browser!\n"

  else
    #Passes the student org data to be emailed
    send = SendEmail.new
    send.emailRecc(fileName)
  end

  #This is used to clear the file after sending recommendations
  File.open(fileName, 'w') do |file| end
  
end
