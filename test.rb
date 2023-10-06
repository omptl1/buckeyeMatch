  require 'mechanize'
require 'nokogiri'

# Initialize Mechanize
agent = Mechanize.new

# Define the URL of the student organization website
url = 'https://activities.osu.edu/involvement/student_organizations/find_a_student_org'

# Prompt the user for search input
print 'Enter your search query: '
search_query = gets.chomp
query_param = "?v=card&s=#{search_query}&c=Columbus"

# Construct the full URL with the user's query
full_url = url + query_param

# Use the agent to fetch the page
page = agent.get(full_url)

# Parse the fetched page with Nokogiri
doc = page.parser

 organization_names = doc.css('h2.c-card__header').map do |header|
  header.text.strip
end

# Print each organization name
organization_names.each do |name|
  puts name
end 
