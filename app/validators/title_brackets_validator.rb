# frozen_string_literal: true

class TitleBracketsValidator < ActiveModel::Validator
  ERROR_MESSAGE = 'Make sure that all brackets in title are closed and not empty'
  BRACKETS = { '(' => ')', '[' => ']', '{' => '}', '<' => '>' }.freeze
  EMPTY_BRACKETS = ['()', '[]', '{}'].freeze

  def validate(record)
    record.errors[:title] << ERROR_MESSAGE unless brackets_balance(record) && brackets_emptiness(record)
  end

  private

  def brackets_balance(record)
    stack = []
    left_brackets = BRACKETS.keys
    right_brackets = BRACKETS.values

    record.title.each_char do |char|
      if left_brackets.include? char
        stack << char
      elsif right_brackets.include? char
        return false if stack.empty? || (BRACKETS[stack.pop] != char)
      end
    end

    stack.empty?
  end

  def brackets_emptiness(record)
    title = record.title

    EMPTY_BRACKETS.none? { |empty_brackets_pair| title.include?(empty_brackets_pair) }
  end
end
