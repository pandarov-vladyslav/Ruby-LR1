# frozen_string_literal: true

module MyApplicationPandarov
  class DatabaseConnector
    attr_reader :db, :config

    def initialize(config)
      @config = config
      @db = nil
    end

    # Метод вибору типу бази даних
    def connect_to_database
      case config['database_config']['database_type']
      when 'sqlite'
        connect_to_sqlite
      when 'mongodb'
        connect_to_mongodb
      else
        raise "Невідомий тип бази даних: #{config['database_config']['database_type']}"
      end
    end

    # Закриття з'єднання
    def close_connection
      puts "З'єднання закрито"
      @db = nil
    end

    private

    # Імітація підключення до SQLite
    def connect_to_sqlite
      puts "Підключення до SQLite (імітація через Hash)"
      @db = { type: 'sqlite', connected: true, data: [] }
    end

    # Імітація підключення до MongoDB
    def connect_to_mongodb
      puts "Підключення до MongoDB (імітація через Hash)"
      @db = { type: 'mongodb', connected: true, data: [] }
    end
  end
end
