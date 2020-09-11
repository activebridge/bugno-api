# frozen_string_literal: true

class StringDifference
  def self.percent(first_string, second_string)
    longer = [first_string.size, second_string.size].max
    same = first_string.each_char.zip(second_string.each_char).select { |a, b| a == b }.size
    ((longer - same) / first_string.size.to_f).round(2)
  end
end
