module MyApplicationPandarov
  module ItemContainer
    module ClassMethods
      def class_info
        { name: name, version: '1.0' }
      end

      def object_count
        @object_count ||= 0
      end

      def increment_object_count
        @object_count ||= 0
        @object_count += 1
      end
    end

    module InstanceMethods
      def add_item(item)
        @items << item
        LoggerManager.log_processed_file("Додано товар: #{item.name}")
      end

      def remove_item(item)
        @items.delete(item)
        LoggerManager.log_processed_file("Видалено товар: #{item.name}")
      end

      def delete_items
        @items.clear
        LoggerManager.log_processed_file("Видалено всі товари")
      end

      def method_missing(method_name, *args, &block)
        if method_name == :show_all_items
          @items.each { |item| puts item.info }
        else
          super
        end
      end
    end

    def self.included(base)
      base.extend ClassMethods
      base.include InstanceMethods
    end
  end
end
