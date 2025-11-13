# frozen_string_literal: true
require 'yaml'
require 'erb'
require 'json'

module MyApplicationPandarov
  class AppConfigLoader
    attr_reader :config_data, :loaded_libs

    def initialize
      @config_data = {}
      @loaded_libs = []
    end

    # Метод автопідключення бібліотек
    def load_libs
      # Системні бібліотеки
      system_libs = %w[date json logger]

      system_libs.each do |lib|
        require lib
        @loaded_libs << lib
      end

      # Локальні бібліотеки з lib
      Dir.glob(File.join(__dir__, '*.rb')).each do |file|
        next if @loaded_libs.include?(file)

        require_relative file
        @loaded_libs << file
      end
    end

    # Завантаження конфігурацій
    def config(main_config_path, additional_config_dir)
      @config_data = load_default_config(main_config_path)
      additional_configs = load_config(additional_config_dir)
      @config_data.merge!(additional_configs)

      yield(@config_data) if block_given?

      @config_data
    end

    # Вивід конфігурації у форматі JSON
    def pretty_print_config_data
      puts JSON.pretty_generate(@config_data)
    end

    # 🔹 Додано класовий метод
    def self.load_config(file_path)
      yaml_content = ERB.new(File.read(file_path)).result
      YAML.safe_load(yaml_content)
    end

    private

    # Завантаження основного YAML файлу
    def load_default_config(file_path)
      yaml_content = ERB.new(File.read(file_path)).result
      YAML.safe_load(yaml_content)
    end

    # Завантаження всіх YAML файлів з директорії
    def load_config(dir)
      configs = {}
      Dir.glob(File.join(dir, '*.yaml')).each do |file|
        next if File.basename(file) == 'default_config.yaml' # не дублювати

        yaml_content = ERB.new(File.read(file)).result
        configs.merge!(YAML.safe_load(yaml_content) || {})
      end
      configs
    end
  end
end
