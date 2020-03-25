# frozen_string_literal: true

class TitleBracketsValidator < ActiveModel::Validator
  ERROR_MESSAGE = 'Make sure that all brackets in title are closed and not empty'
  BRACKETS_LEFT_SIDE = ['(', '[', '{', '<'].freeze
  BRACKETS_RIGHT_SIDE = [')', ']', '}', '>'].freeze
  BRACKETS_PAIRS = { '(' => ')', '[' => ']', '{' => '}', '<' => '>' }.freeze
  EMPTY_BRACKETS = ['()', '[]', '{}'].freeze

  def validate(record)
    record.errors[:title] << ERROR_MESSAGE unless brackets_balance(record) && brackets_emptiness(record)
  end

  private

  def brackets_balance(record)
    stack = []

    record.title.each_char do |char|
      if BRACKETS_LEFT_SIDE.include? char
        stack << char
      elsif BRACKETS_RIGHT_SIDE.include? char
        return false if stack.empty? || (BRACKETS_PAIRS[stack.pop] != char)
      end
    end

    stack.empty?
  end

  def brackets_emptiness(record)
    title = record.title

    EMPTY_BRACKETS.none? { |empty_brackets_pair| title.include?(empty_brackets_pair) }
  end
end
