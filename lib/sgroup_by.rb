# frozen_string_literal: true

require_relative "sgroup_by/version"

# SgroupBy.new(enum).call do ||
module SgroupBy
  class Error < StandardError; end

  def self.new(enum, &block)
    Agent.new(enum, &block)
  end

  class Agent
    def initialize(enum, &block)
      @enum = enum
      @block = block
    end

    def call(&block)
      key = nil

      rows = []

      @enum.each_with_index do |row, i|
        if i == 0
          key = @block.call(row)
          rows << row
        else
          key1 = @block.call(row)

          if key == key1
            rows << row
          else
            block.call(key, rows)
            key = key1
            rows = [row]
          end
        end
      end

      block.call(key, rows) unless rows.empty?

      @enum
    end
  end
end
