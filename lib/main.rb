# frozen_string_literal: true

require 'yaml'
require 'erb'
require 'json'
require 'logger'

# Надійне підключення локальних бібліотек
require_relative 'app_config_loader'
require_relative 'logger_manager'

# Підключаємо модуль
include MyApplicationPandarov

begin
  # Завантаження бібліотек
  loader = AppConfigLoader.new
  loader.load_libs

  # Завантаження конфігурацій
  loader.config('config/default_config.yaml', 'config') do |config|
    puts "Конфігурації завантажено!"
    loader.pretty_print_config_data

    # Ініціалізація логування
    LoggerManager.initialize_logger(config['logging'])
    LoggerManager.log_processed_file('config.yaml')
  end

rescue StandardError => e
  # Логування помилок
  if defined?(LoggerManager) && LoggerManager.respond_to?(:log_error)
    LoggerManager.log_error("Помилка при завантаженні конфігурацій: #{e.message}")
  else
    puts "Помилка: #{e.message}"
  end
end
