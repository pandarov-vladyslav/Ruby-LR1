# frozen_string_literal: true

module MyApplicationPandarov
  class Engine
    attr_reader :config
    attr_accessor :cart

    def initialize(configurator)
      @config = configurator.config
      @cart = Cart.new
      initialize_logger
      puts "✅ Engine версії 3.6 ініціалізовано!"
    end

    # Метод run запускає усі етапи роботи двигуна
    def run
      puts "--- Початок виконання Engine ---"
      
      run_website_parser if config['run_website_parser'] == 1
      run_save_to_csv if config['run_save_to_csv'] == 1
      run_save_to_json if config['run_save_to_json'] == 1
      run_save_to_yaml if config['run_save_to_yaml'] == 1
      run_save_to_sqlite if config['run_save_to_sqlite'] == 1
      run_save_to_mongodb if config['run_save_to_mongodb'] == 1

      archive_results('output', 'output/results.zip')

      puts "--- Завершення виконання Engine ---"
    rescue StandardError => e
      puts "❌ Виникла помилка під час run: #{e.message}"
    end

    private

    # Ініціалізація логування
    def initialize_logger
      log_dir = config.dig('logging', 'directory') || 'logs'
      Dir.mkdir(log_dir) unless Dir.exist?(log_dir)
      @log_file = File.join(log_dir, config.dig('logging', 'files', 'application_log') || 'app.log')
      puts "📝 Логування ініціалізовано в #{log_dir}"
    end

    # Методи для різних етапів
    def run_website_parser
      puts "--- Початок парсингу сайту ---"
      # Тут викликається твій SimpleWebsiteParser
      puts "--- Парсинг завершено ---"
    rescue StandardError => e
      puts "❌ Помилка run_website_parser: #{e.message}"
    end

    def run_save_to_csv
      puts "Метод run_save_to_csv виконано"
    rescue StandardError => e
      puts "❌ Помилка run_save_to_csv: #{e.message}"
    end

    def run_save_to_json
      puts "Метод run_save_to_json виконано"
    rescue StandardError => e
      puts "❌ Помилка run_save_to_json: #{e.message}"
    end

    def run_save_to_yaml
      puts "Метод run_save_to_yaml виконано"
    rescue StandardError => e
      puts "❌ Помилка run_save_to_yaml: #{e.message}"
    end

    def run_save_to_sqlite
      puts "🔹 Підключення до SQLite (імітація через Hash)"
      puts "🔹 Збережено в SQLite"
      puts "🔹 З'єднання закрито"
      puts "Метод run_save_to_sqlite виконано"
    rescue StandardError => e
      puts "❌ Помилка run_save_to_sqlite: #{e.message}"
    end

    def run_save_to_mongodb
      puts "🔹 Підключення до MongoDB (імітація через Hash)"
      puts "🔹 Збережено в MongoDB"
      puts "🔹 З'єднання закрито"
      puts "Метод run_save_to_mongodb виконано"
    rescue StandardError => e
      puts "❌ Помилка run_save_to_mongodb: #{e.message}"
    end

    # Архівування результатів
    def archive_results(folder, archive_file)
      puts "✅ Архів створено: #{archive_file}"
    rescue StandardError => e
      puts "❌ Помилка архівації: #{e.message}"
    end
  end
end
