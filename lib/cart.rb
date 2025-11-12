require 'json'
require 'csv'
require 'yaml'
require_relative 'item_container'
require_relative 'item' # чтобы работать с Item

module MyApplicationPandarov
  class Cart
    include ItemContainer
    include Enumerable

    attr_accessor :items

    def initialize
      @items = []
      self.class.increment_object_count
      LoggerManager.log_processed_file("Ініціалізовано Cart")
    end

    # Enumerable
    def each(&block)
      @items.each(&block)
    end

    # Сохранение в различные форматы
    def save_to_file(file_path)
      File.open(file_path, 'w') { |f| @items.each { |item| f.puts item.to_s } }
      LoggerManager.log_processed_file("Збережено у текстовий файл: #{file_path}")
    end

    def save_to_json(file_path)
      File.write(file_path, JSON.pretty_generate(@items.map(&:to_h)))
      LoggerManager.log_processed_file("Збережено у JSON файл: #{file_path}")
    end

    def save_to_csv(file_path)
      CSV.open(file_path, 'w') do |csv|
        csv << @items.first.to_h.keys
        @items.each { |item| csv << item.to_h.values }
      end
      LoggerManager.log_processed_file("Збережено у CSV файл: #{file_path}")
    end

    def save_to_yml(directory)
      Dir.mkdir(directory) unless Dir.exist?(directory)
      @items.each do |item|
        file_name = File.join(directory, "#{item.name.downcase.gsub(' ', '_')}.yml")
        File.write(file_name, item.to_h.to_yaml)
      end
      LoggerManager.log_processed_file("Збережено у YAML файли в папці: #{directory}")
    end

    # Генерация тестовых данных
    def generate_test_items(count = 5)
      count.times { add_item(Item.generate_fake) }
    end
  end
end
