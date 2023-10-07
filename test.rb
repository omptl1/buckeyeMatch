require 'mechanize'
require 'nokogiri'

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
 
organization_data = doc.xpath('//strong/a/text()').map do |header|
  {
    name: header.text.strip,
    id: doc.at_css('body')['id']
  }
end

organization_data.each_with_index do |org, index|
  puts "#{index + 1}. #{org[:name]}"
end

# Prompt user to choose a club
puts "\n Enter the club you're curious about in number:"
choice = gets.chomp.to_i

# Ensure valid input
if choice >= 1 && choice <= organization_data.size
  chosen_org = organization_data[choice - 1]
  org_id = chosen_org[:id] # Ensure you've extracted the ID correctly above

  details_url = "https://activities.osu.edu/involvement/student_organizations/find_a_student_org?i=#{org_id}&v=list&s=#{search_query}&c=Columbus&page=0"
  puts details_url
else
    abort("An invalid number was entered! Closing the program.")
end
=begin  
# Fetch and parse the chosen club's details
  details_page = agent.get(details_url)
  club_userwant = Nokogiri::HTML(details_page.body)

  # Target the <th> element that contains the text "Purpose Statement"
purpose_th = club_userwant.at_css('th:contains("Purpose Statement:") i')
  # Extract the text content of the following <td> sibling
  purpose_text = purpose_th.next_element.text.strip

  puts purpose_text
else
  puts "Invalid choice!"
end
=end
