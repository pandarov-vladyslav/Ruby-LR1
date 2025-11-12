# frozen_string_literal: true
require 'yaml'
require 'erb'
require 'json'
require 'logger'

require_relative 'logger_manager'
require_relative 'app_config_loader'
require_relative 'item'

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

  # 4️⃣ Тестування класу Item
  puts "\n--- Тестування Item ---"

  # Создание фейкового товара
  item1 = Item.generate_fake
  puts "Фейковий товар: #{item1.info}"

  # Создание товара с блоком
  item2 = Item.new(name: "Тестовий товар", price: 150) do |i|
    i.description = "Це тестовий опис"
    i.category = "Вітаміни"
    i.image_path = "media/vitamins/test_item.png"
  end
  puts "Товар з блоком: #{item2.info}"

  # Обновление через блок
  item2.update do |i|
    i.price = 200
    i.name = "Оновлений тестовий товар"
  end
  puts "Після оновлення: #{item2.info}"

  # Сравнение товаров
  puts "Порівняння по ціні: item1 <=> item2 = #{item1 <=> item2}"

rescue StandardError => e
  LoggerManager.log_error("Помилка при завантаженні конфігурацій або тестуванні Item: #{e.message}")
end
