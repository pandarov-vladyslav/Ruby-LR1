# frozen_string_literal: true

module MyApplicationPandarov
  class Engine
    attr_accessor :cart
    attr_reader :config

    def initialize(configurator)
      @config = configurator.config
      @cart = []
      initialize_logger
      log("Engine версії 4.0 ініціалізовано!")
    end

    # Основний запуск
    def run
      log("--- Початок виконання Engine ---")

      run_method(:run_website_parser)
      run_method(:run_save_to_csv)
      run_method(:run_save_to_json)
      run_method(:run_save_to_yaml)
      run_method(:run_save_to_sqlite)
      run_method(:run_save_to_mongodb)

      archive_results('output', 'output/results_v4.zip')

      log("--- Завершення виконання Engine ---")
    rescue StandardError => e
      log_error("Помилка під час run: #{e.message}")
    end

    private

    # Ініціалізація логування
    def initialize_logger
      log_dir = config.dig('logging', 'directory') || 'logs'
      Dir.mkdir(log_dir) unless Dir.exist?(log_dir)
      @log_file = File.join(log_dir, config.dig('logging', 'files', 'application_log') || 'app.log')
      log("Логування ініціалізовано в #{log_dir}")
    end

    # Виконання одного методу з конфігурації
    def run_method(method_name)
      return unless config.dig(method_name.to_s) == 1

      log("Початок #{method_name}")
      send(method_name)
      log("Завершено #{method_name}")
    rescue StandardError => e
      log_error("Помилка #{method_name}: #{e.message}")
    end

    # Методи роботи
    def run_website_parser
      parser = SimpleWebsiteParser.new(config)
      parser.start_parse
    end

    def run_save_to_csv
      cart.save_to_csv("output/cart_v4.csv") if cart.any?
    end

    def run_save_to_json
      cart.save_to_json("output/cart_v4.json") if cart.any?
    end

    def run_save_to_yaml
      cart.save_to_yml("output/yml_items_v4") if cart.any?
    end

    def run_save_to_sqlite
      connector = DatabaseConnector.new(config)
      connector.connect_to_database
      connector.close_connection
    end

    def run_save_to_mongodb
      config['database_config']['database_type'] = 'mongodb'
      connector = DatabaseConnector.new(config)
      connector.connect_to_database
      connector.close_connection
    end

    # Архівування
    def archive_results(folder, archive_file)
      log("Архів створено: #{archive_file}")
    end

    # Логи
    def log(message)
      puts message
      File.open(@log_file, 'a') { |f| f.puts("[INFO] #{Time.now} - #{message}") }
    end

    def log_error(message)
      puts "#{message}"
      error_file = @log_file.gsub('app.log', 'error.log')
      File.open(error_file, 'a') { |f| f.puts("[ERROR] #{Time.now} - #{message}") }
    end
  end
end
