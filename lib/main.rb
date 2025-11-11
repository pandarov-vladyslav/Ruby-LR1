require 'nokogiri'
require 'httparty'

url = "https://example.com"
response = HTTParty.get(url)
doc = Nokogiri::HTML(response.body)

puts "Заголовок сторінки:"
puts doc.css('h1').text
