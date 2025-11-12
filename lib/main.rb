# frozen_string_literal: true

require 'nokogiri'
require 'httparty'
require 'csv'
require 'json'

BASE_URL = 'https://quotes.toscrape.com/page/'
OUTPUT_CSV = 'output/data.csv'
OUTPUT_JSON = 'output/data.json'

quotes = []

puts 'Збір даних...'

(1..3).each do |page|
  response = HTTParty.get("#{BASE_URL}#{page}/")
  document = Nokogiri::HTML(response.body)

  document.css('.quote').each do |quote_block|
    text = quote_block.css('.text').text.strip
    author = quote_block.css('.author').text.strip
    tags = quote_block.css('.tag').map(&:text).join(', ')

    quotes << { text: text, author: author, tags: tags }
  end
end

puts "Отримано #{quotes.size} цитат."

# Збереження у CSV
CSV.open(OUTPUT_CSV, 'w', write_headers: true, headers: %w[text author tags]) do |csv|
  quotes.each { |q| csv << q.values }
end

# Збереження у JSON
File.write(OUTPUT_JSON, JSON.pretty_generate(quotes))

puts 'Дані збережено у:'
puts " - #{OUTPUT_CSV}"
puts " - #{OUTPUT_JSON}"
