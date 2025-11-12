# frozen_string_literal: true
module MyApplicationPandarov
  class Configurator
    attr_reader :config

    DEFAULT_CONFIG = {
      run_website_parser: 0,
      run_save_to_csv: 0,
      run_save_to_json: 0,
      run_save_to_yaml: 0,
      run_save_to_sqlite: 0,
      run_save_to_mongodb: 0
    }.freeze

    # Конструктор
    def initialize
      @config = DEFAULT_CONFIG.dup
    end

    # Метод для налаштування конфігурації
    def configure(overrides = {})
      overrides.each do |key, value|
        if @config.key?(key)
          @config[key] = value
          LoggerManager.log_processed_file("Налаштовано #{key} = #{value}")
        else
          warn "⚠️ Недійсний ключ конфігурації: #{key}"
          LoggerManager.log_error("Недійсний ключ конфігурації: #{key}")
        end
      end
    end

    # Класовий метод — повертає список доступних ключів
    def self.available_methods
      DEFAULT_CONFIG.keys
    end
  end
end
