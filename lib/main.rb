# frozen_string_literal: true

require 'yaml'
require 'json'
require_relative 'app_config_loader'
require_relative 'logger_manager'
require_relative 'item'
require_relative 'cart'
require_relative 'configurator'
require_relative 'simple_website_parser'
require_relative 'database_connector'

include MyApplicationPandarov

begin
  # -----------------------------
  # 1️⃣ Завантаження конфігурацій
  # -----------------------------
  loader = AppConfigLoader.new
  loader.load_libs

  loader.config('config/default_config.yaml', 'config') do |config|
    puts "✅ Конфігурації завантажено!"
    loader.pretty_print_config_data

    # 2️⃣ Ініціалізація логування
    LoggerManager.initialize_logger(config['logging'])
    LoggerManager.log_processed_file('config.yaml')
  end

  # -----------------------------
  # 3️⃣ Тестування Cart / ItemCollection
  # -----------------------------
  puts "\n--- Тестування Cart ---"
  cart = Cart.new
  cart.generate_test_items(5)
  puts "Додано фейкові товари:"
  cart.show_all_items

  # Додаємо спеціальний товар
  item = Item.new(name: "Спеціальний товар", price: 999) do |i|
    i.description = "Це тестовий опис"
    i.category = "Вітаміни"
    i.image_path = "media/vitamins/special_item.png"
  end
  cart.add_item(item)

  puts "\nПісля додавання спеціального товару:"
  cart.show_all_items

  # Вибір дорогих товарів
  expensive_items = cart.select { |i| i.price > 500 }
  puts "\nТовари з ціною > 500:"
  expensive_items.each { |i| puts i.info }

  # Збереження у файли
  cart.save_to_file("output/cart.txt")
  cart.save_to_json("output/cart.json")
  cart.save_to_csv("output/cart.csv")
  cart.save_to_yml("output/yml_items")

  # -----------------------------
  # 4️⃣ Тестування Configurator
  # -----------------------------
  puts "\n--- Тестування Configurator ---"
  configurator = Configurator.new
  puts "Доступні методи: #{Configurator.available_methods}"

  configurator.configure(
    run_website_parser: 1,
    run_save_to_csv: 1,
    run_save_to_yaml: 1,
    run_save_to_sqlite: 1,
    run_save_to_mongodb: 1,
    invalid_key: 1 # Попередження
  )

  puts "\nПоточна конфігурація Configurator:"
  configurator.config.each { |k, v| puts "#{k}: #{v}" }

  # -----------------------------
  # 5️⃣ Тестування SimpleWebsiteParser
  # -----------------------------
  puts "\n--- Тестування SimpleWebsiteParser ---"
  config = AppConfigLoader.load_config('config/yaml_config/app_config.yaml')
  parser = MyApplicationPandarov::SimpleWebsiteParser.new(config)
  parser.start_parse


  # -----------------------------
  # 6️⃣ Тестування DatabaseConnector
  # -----------------------------
  puts "\n--- Тестування DatabaseConnector ---"

  puts "🔹 Тест SQLite"
  sqlite_connector = DatabaseConnector.new(config)
  sqlite_connector.connect_to_database
  puts "db = #{sqlite_connector.db.inspect}"
  sqlite_connector.close_connection

  puts "\n🔹 Тест MongoDB"
  config['database_config']['database_type'] = 'mongodb'
  mongo_connector = DatabaseConnector.new(config)
  mongo_connector.connect_to_database
  puts "db = #{mongo_connector.db.inspect}"
  mongo_connector.close_connection

rescue StandardError => e
  LoggerManager.log_error("Помилка виконання main.rb: #{e.message}")
  puts "❌ Виникла помилка: #{e.message}"
end
