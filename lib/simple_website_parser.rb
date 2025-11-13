# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'json'
require 'csv'
require 'yaml'

module MyApplicationPandarov
  class SimpleWebsiteParser
    attr_reader :config, :logger

    def initialize(config)
      @config = config
      @logger = LoggerManager.logger
      @base_url = config['parser']['base_url'] rescue 'https://example.com'
      @output_path = 'output/parser_results'
      Dir.mkdir(@output_path) unless Dir.exist?(@output_path)
      @logger.info("✅ Ініціалізовано SimpleWebsiteParser з базовою URL: #{@base_url}")
    end

    # Основний метод запуску парсера
    def start_parse
      @logger.info('🚀 Починаємо парсинг...')
      puts "\n--- Початок парсингу сайту ---"

      items = parse_fake_website
      puts "Отримано #{items.size} елементів"

      save_to_json(items)
      save_to_csv(items)
      save_to_yaml(items)

      @logger.info('✅ Парсинг завершено успішно.')
      puts "--- Парсинг завершено ---"
    rescue StandardError => e
      @logger.error("❌ Помилка під час парсингу: #{e.message}")
      puts "❌ Помилка під час парсингу: #{e.message}"
    end

    private

    # Імітація роботи парсера
    def parse_fake_website
      [
        { name: 'Вітамін C', price: 120, category: 'Вітаміни', link: "#{@base_url}/vitamin-c" },
        { name: 'Магній B6', price: 240, category: 'Мінерали', link: "#{@base_url}/magnesium-b6" },
        { name: 'Цинк', price: 180, category: 'Мікроелементи', link: "#{@base_url}/zinc" },
        { name: 'Омега 3', price: 320, category: 'Жири', link: "#{@base_url}/omega-3" }
      ]
    end

    # Збереження результатів
    def save_to_json(data)
      file = File.join(@output_path, 'parsed_items.json')
      File.write(file, JSON.pretty_generate(data))
      @logger.info("💾 Дані збережено у JSON: #{file}")
    end

    def save_to_csv(data)
      file = File.join(@output_path, 'parsed_items.csv')
      CSV.open(file, 'w') do |csv|
        csv << data.first.keys
        data.each { |row| csv << row.values }
      end
      @logger.info("💾 Дані збережено у CSV: #{file}")
    end

    def save_to_yaml(data)
      file = File.join(@output_path, 'parsed_items.yml')
      File.write(file, YAML.dump(data))
      @logger.info("💾 Дані збережено у YAML: #{file}")
    end
  end
end
