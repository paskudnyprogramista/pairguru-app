source 'https://rubygems.org'

gem 'rails', '5.2'

gem 'annotate'
gem 'bootstrap-sass'
gem 'devise'
gem 'draper'
gem 'haml-rails'
gem 'jquery-rails'
gem 'sass-rails'
gem 'sqlite3'
gem 'uglifier'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# A lightning fast JSON:API serializer for Ruby Objects.
gem 'fast_jsonapi'

# HTTP (The Gem! a.k.a. http.rb) is an easy-to-use client library for making requests from Ruby.
gem 'http'

# dry-monads is a set of common monads for Ruby.
# https://dry-rb.org/gems/dry-monads
gem 'dry-monads'

# dry-struct is a gem built on top of dry-types which provides virtus-like DSL for defining typed struct classes.
# https://dry-rb.org/gems/dry-struct/
gem 'dry-struct'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'bullet'
  gem 'letter_opener'
  gem 'pry-rails'
  gem 'rails-erd'
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'rspec-json_expectations'
  gem 'shoulda-matchers'
end

group :development, :test do
  gem 'capybara'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'listen'
  gem 'rspec-rails'
  gem 'simplecov'
end

group :development, :test, :continuouse_testing do
  gem 'rubocop', '~> 0.80.1', require: false
  gem 'rubocop-rails', require: false
end
