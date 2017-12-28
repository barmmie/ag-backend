module Store
  module Attributes
    extend ActiveSupport::Concern

    class_methods do
      def store_attributes(column, &blk)
        config = Config.new(column, &blk)

        define_method(column) do
          Proxy.new(self, config)
        end

        define_method("#{column}=") do |params|
          Proxy.new(self, config).merge(params)
        end
      end
    end
  end

  class Config
    attr_reader :column, :attributes

    def initialize(column, &blk)
      @column = column
      @attributes = []
      instance_eval(&blk)
    end

    def attribute(*args)
      attributes << args
    end
  end

  class Proxy
    def initialize(model, config)
      @model = model
      @config = config
      @attribute_map = config.attributes.index_by(&:first).stringify_keys
      instance_eval do
        config.attributes.each do |(key, _type, options)|
          define_reader(key, options)
          define_writer(key)
        end
      end
    end

    def merge(params)
      params.stringify_keys.slice(*@attribute_map.keys).each do |key, value|
        write_value(key, value)
      end
    end

    def update(params)
      merge(params)
      @model.save
    end

    def to_h
      @config.attributes.each_with_object({}) do |(key, _type, options), memo|
        memo[key.to_s] = read_value(key.to_s, options)
      end
    end

    def keys
      @config.attributes.map(&:first)
    end

    def inspect
      to_h.to_s
    end

    private

    def read_value(key, options)
      cast(key, @model[@config.column].fetch(key, options.try(:[], :default)))
    end

    def write_value(key, value)
      @model[@config.column][key] = cast(key, value)
    end

    def type(key)
      @attribute_map[key][1]
    end

    def cast(key, value)
      return value if type(key) == :hash
      ActiveRecord::Type.const_get(type(key).to_s.classify).new.cast(value)
    end

    def define_reader(key, options)
      define_singleton_method(key) do
        read_value(key.to_s, options)
      end
    end

    def define_writer(key)
      define_singleton_method("#{key}=") do |value|
        write_value(key.to_s, value)
      end
    end
  end
end
