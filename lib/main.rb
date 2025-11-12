# frozen_string_literal: true
require 'yaml'
require 'erb'
require 'json'
require 'logger'
require_relative File.join(__dir__, 'app_config_loader')
require_relative File.join(__dir__, 'logger_manager')
require_relative File.join(__dir__, 'item')
require_relative File.join(__dir__, 'cart')

include MyApplicationPandarov

# 1️⃣ Завантаження бібліотек
loader = AppConfigLoader.new
loader.load_libs

# 2️⃣ Завантаження конфігурацій
loader.config('config/default_config.yaml', 'config') do |config|
  puts "✅ Конфігурації завантажено!"
  loader.pretty_print_config_data

  # 3️⃣ Ініціалізація логування
  LoggerManager.initialize_logger(config['logging'])
  LoggerManager.log_processed_file('config.yaml')

  # -----------------------------
  # 4️⃣ Тестування Cart / ItemCollection
  # -----------------------------
  puts "\n--- Тестування Cart ---"

  cart = Cart.new

  # Генерація 5 тестових товарів
  cart.generate_test_items(5)
  puts "Додано фейкові товари:"
  cart.show_all_items

  # Додамо конкретний товар через блок
  item = Item.new(name: "Спеціальний товар", price: 999) do |i|
    i.description = "Це тестовий опис"
    i.category = "Вітаміни"
    i.image_path = "media/vitamins/special_item.png"
  end
  cart.add_item(item)

  puts "\nПісля додавання спеціального товару:"
  cart.show_all_items

  # Використовуємо методи Enumerable
  expensive_items = cart.select { |i| i.price > 500 }
  puts "\nТовари з ціною > 500:"
  expensive_items.each { |i| puts i.info }

  # Збереження у файли
  cart.save_to_file("output/cart.txt")
  cart.save_to_json("output/cart.json")
  cart.save_to_csv("output/cart.csv")
  cart.save_to_yml("output/yml_items")

rescue StandardError => e
  LoggerManager.log_error("Помилка при завантаженні конфігурацій: #{e.message}")
end
