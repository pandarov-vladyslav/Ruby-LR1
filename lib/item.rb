# frozen_string_literal: true
require 'faker'
require_relative 'logger_manager'

module MyApplicationPandarov
  class Item
    include Comparable

    attr_accessor :name, :price, :description, :category, :image_path

    # Конструктор с поддержкой блока
    def initialize(attributes = {})
      @name        = attributes[:name] || "Unnamed Product"
      @price       = attributes[:price] || 0
      @description = attributes[:description] || "No description"
      @category    = attributes[:category] || "Uncategorized"
      @image_path  = attributes[:image_path] || "media/default.png"

      yield(self) if block_given?

      LoggerManager.log_processed_file("Item initialized: #{self.name}") rescue nil
    end

    # Печать объекта
    def to_s
      instance_variables.map do |var|
        "#{var.to_s.delete('@')}: #{instance_variable_get(var)}"
      end.join(', ')
    end
    alias_method :info, :to_s

    # Преобразование в хеш
    def to_h
      instance_variables.each_with_object({}) do |var, hash|
        hash[var.to_s.delete('@')] = instance_variable_get(var)
      end
    end

    # inspect
    def inspect
      "#<Item #{to_s}>"
    end

    # Обновление атрибутов через блок
    def update
      yield(self) if block_given?
      LoggerManager.log_processed_file("Item updated: #{self.name}") rescue nil
    end

    # Comparable — сравнение по цене
    def <=>(other)
      self.price <=> other.price
    end

    # Генерация фейкового объекта
    def self.generate_fake
      new(
        name: Faker::Commerce.product_name,
        price: Faker::Commerce.price(range: 10..500),
        description: Faker::Lorem.sentence(word_count: 10),
        category: Faker::Commerce.department,
        image_path: "media/#{Faker::File.unique.file_name(dir: '', ext: 'png')}"
      )
    end
  end
end
