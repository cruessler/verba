source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 5.1', '< 5.2'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
# https://github.com/seyhunak/twitter-bootstrap-rails
# The gem is used for helper methods and generators.
# The css and js files are managed by bower
gem 'twitter-bootstrap-rails'
# Version 3.0 seems to have a dependency on grease which makes some tests fail.
# See https://stackoverflow.com/questions/46825582
gem 'less-rails', '~> 2.8'

# Use jquery as the JavaScript library (made obsolete by the use of bower)
# gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'

gem 'thin'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

group :development do
  # Use Capistrano for deployment
  # http://capistranorb.com/documentation/getting-started/installation/
  gem 'capistrano-rails', '~> 1.1.1'

  # This gem was added to address an error message provided by ActiveSupport
  # 5.1.4.
  gem 'listen'
end

# Use debugger
# gem 'debugger', group: [:development, :test]

# https://github.com/svenfuchs/rails-i18n
gem 'rails-i18n', '~> 4.0.0.pre' # For 4.0.x

# https://github.com/plataformatec/simple_form
gem 'simple_form', '~> 3.2'

# https://github.com/plataformatec/devise
# http://railscasts.com/episodes/209-introducing-devise
# Used for authentication and access control
gem 'devise', '~> 4.0'

# https://github.com/tigrish/devise-i18n
# https://github.com/plataformatec/devise/wiki/I18n
# Used for l18n of devise
gem 'devise-i18n'

gem 'active_model_serializers', '~> 0.10.0'

# Rails 5.0 has removed `assigns` in controllers test and extracted the
# functionality to a gem.
gem 'rails-controller-testing'
