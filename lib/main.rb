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
require_relative 'engine'

include MyApplicationPandarov

begin
  # Завантаження конфігурацій
  loader = AppConfigLoader.new
  loader.load_libs

  loader.config('config/default_config.yaml', 'config') do |config|
    puts "Конфігурації завантажено!"
    loader.pretty_print_config_data

    LoggerManager.initialize_logger(config['logging'])
  end

  # Тест Cart
  cart = Cart.new
  cart.generate_test_items(5)
  item = Item.new(name: "Спеціальний товар", price: 999) do |i|
    i.description = "Це тестовий опис"
    i.category = "Вітаміни"
    i.image_path = "media/vitamins/special_item.png"
  end
  cart.add_item(item)

  # Configurator
  configurator = Configurator.new
  configurator.configure(
    run_website_parser: 1,
    run_save_to_csv: 1,
    run_save_to_json: 1,
    run_save_to_yaml: 1,
    run_save_to_sqlite: 1,
    run_save_to_mongodb: 1
  )

  # Engine 4.0
  engine = Engine.new(configurator)
  engine.cart = cart
  engine.run

rescue StandardError => e
  LoggerManager.log_error("Помилка main.rb: #{e.message}")
  puts "Виникла помилка: #{e.message}"
end
