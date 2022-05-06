# frozen_string_literal: true

require_relative "sgroup_by/version"

#
# When grouping keys are forward matchable, partial loading allows grouping
# while avoiding loading all data at once.
#
# ```rb
# # Example
#
# primes = Prime.each(99999).extend(SgroupBy)
#
# grouping = primes.sgroup_by {|value| value.to_s.length }
#
# grouping.each {|key, values| p [key, values.count] }
# ```
#
module SgroupBy
  def sgroup_by(&block)
    SgroupBy.new(self, &block)
  end

  def self.extended(object)
    raise ArgumentError unless object.is_a?(Enumerable)
  end

  def self.new(enum, &block)
    raise ArgumentError unless enum.is_a?(Enumerable)

    Enumerator.new do |y|
      key = nil
      values = []

      enum.each_with_index do |row, i|
        if i == 0
          key = block.call(row)
          values << row
        else
          key1 = block.call(row)

          if key == key1
            values << row
          else
            y << [key, values]

            key = key1
            values = [row]
          end
        end
      end

      y << [key, values] unless values.empty?
    end
  end
end
