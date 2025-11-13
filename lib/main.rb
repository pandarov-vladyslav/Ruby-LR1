# frozen_string_literal: true
require 'yaml'
require 'erb'
require 'json'
require 'logger'
require_relative File.join(__dir__, 'app_config_loader')
require_relative File.join(__dir__, 'logger_manager')
require_relative File.join(__dir__, 'item')
require_relative File.join(__dir__, 'cart')
require_relative File.join(__dir__, 'configurator')
require_relative File.join(__dir__, 'simple_website_parser')

include MyApplicationPandarov

begin
  # 1️⃣ Завантаження бібліотек
  loader = AppConfigLoader.new
  loader.load_libs

  # 2️⃣ Завантаження конфігурацій
  app_config = nil
  loader.config('config/default_config.yaml', 'config') do |config|
    puts "✅ Конфігурації завантажено!"
    loader.pretty_print_config_data
    app_config = config # зберігаємо для подальшого використання

    # 3️⃣ Ініціалізація логування
    LoggerManager.initialize_logger(config['logging'])
    LoggerManager.log_processed_file('config.yaml')
  end

  # -----------------------------
  # 4️⃣ Тестування Cart / ItemCollection
  # -----------------------------
  puts "\n--- Тестування Cart ---"

  cart = Cart.new
  cart.generate_test_items(5)
  puts "Додано фейкові товари:"
  cart.show_all_items

  # Додаємо тестовий товар
  item = Item.new(name: "Спеціальний товар", price: 999) do |i|
    i.description = "Це тестовий опис"
    i.category = "Вітаміни"
    i.image_path = "media/vitamins/special_item.png"
  end
  cart.add_item(item)

  puts "\nПісля додавання спеціального товару:"
  cart.show_all_items

  # Приклад використання Enumerable
  expensive_items = cart.select { |i| i.price > 500 }
  puts "\nТовари з ціною > 500:"
  expensive_items.each { |i| puts i.info }

  # Збереження у файли
  cart.save_to_file("output/cart.txt")
  cart.save_to_json("output/cart.json")
  cart.save_to_csv("output/cart.csv")
  cart.save_to_yml("output/yml_items")

  # -----------------------------
  # 5️⃣ Тестування Configurator (3.3)
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
    invalid_key: 1 # навмисно некоректний ключ
  )

  puts "\nПоточна конфігурація Configurator:"
  configurator.config.each do |key, value|
    puts "#{key}: #{value}"
  end

  # -----------------------------
  # 6️⃣ Тестування SimpleWebsiteParser (3.4)
  # -----------------------------
  puts "\n--- Тестування SimpleWebsiteParser ---"

  # ✅ Використовуємо вже завантажену конфігурацію
  parser = MyApplicationPandarov::SimpleWebsiteParser.new(loader.config_data)
  parser.start_parse


rescue StandardError => e
  LoggerManager.log_error("Помилка виконання main.rb: #{e.message}")
  puts "❌ Виникла помилка: #{e.message}"
end
