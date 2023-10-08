require 'mechanize'
require 'nokogiri'
require 'open-uri'

# Initialize Mechanize
agent = Mechanize.new

# Define the URL of the student organization website
url = 'https://activities.osu.edu/involvement/student_organizations/find_a_student_org'

# Visit the website
page = agent.get(url)

# Prompt the user for search input
print 'Enter your search query: '
search_query = gets.chomp

# Find the search form
search_form = page.forms.find do |form|
    form.has_field?('ctl00$ContentBody$pageFormControl$txt_search')
  end
  
  # Check if the form was found
  if search_form.nil?
    puts 'Search form not found on the page.'
  else
    # Fill in the search query and submit the form
    search_form['ctl00$ContentBody$pageFormControl$txt_search'] = search_query
    search_results_page = search_form.submit
  
    # Extract and display search results
    results = search_results_page.css('div.c-search-result')
    if results.empty?
      puts 'No results found.'
    else
      puts 'Search results:'
      results.each_with_index do |result, index|
        org_name = result.css('h3 a').text
        campus = result.css('div.c-search-result__campus').text
        puts "#{index + 1}. #{org_name} (Campus: #{campus})"
      end
    end
end
  

if 
  #Holds the name of the text file that will contain student org info
  fileName = "student_org.txt"
  #Will be used to put the scraped data into a txt file
  File.open(fileName, 'w') do |file|
   #Need to put scrapped data into file
   #fileName.puts()
  end




  
  
  
