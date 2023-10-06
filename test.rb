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

full_url = url + query_param
page = agent.get(full_url)
doc = page.parser

puts doc.content

  
  
