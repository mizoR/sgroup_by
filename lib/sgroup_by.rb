# frozen_string_literal: true

require_relative "sgroup_by/version"

#
# When grouping keys are forward matchable, partial loading allows grouping
# while avoiding loading all data at once.
#
# ```rb
# # Example
#
# grouping = SgroupBy.new(Prime.each(99999)) {|value| value.to_s.length }
#
# grouping.call {|key, values| p [key, values.count] }
# ```
#
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
