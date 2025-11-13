# frozen_string_literal: true
require 'logger'

module MyApplicationPandarov
  class LoggerManager
    class << self
      attr_reader :logger

      # Ініціалізація логера
      def initialize_logger(logging_config)
        log_dir = logging_config['directory'] || 'logs'
        Dir.mkdir(log_dir) unless Dir.exist?(log_dir)

        log_file = File.join(log_dir, logging_config['files']['application_log'] || 'app.log')
        @logger = Logger.new(log_file, 'daily')
        @logger.level = level_from_string(logging_config['level'])
        @logger.formatter = proc do |severity, datetime, _progname, msg|
          "[#{datetime}] #{severity}: #{msg}\n"
        end
      end

      # Логування обробленого файлу
      def log_processed_file(file_name)
        @logger.info("Оброблено файл: #{file_name}") if @logger
      end

      # Логування помилки
      def log_error(message)
        if @logger
          @logger.error("Помилка: #{message}")
        else
          puts "ERROR: #{message}"
        end
      end

      private

      def level_from_string(level_str)
        case level_str&.upcase
        when 'DEBUG' then Logger::DEBUG
        when 'INFO' then Logger::INFO
        when 'WARN' then Logger::WARN
        when 'ERROR' then Logger::ERROR
        else Logger::INFO
        end
      end
    end
  end
end
