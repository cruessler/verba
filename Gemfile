source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 6.1', '< 6.2'

# Use PostgreSQL as the database for Active Record
gem 'pg', '~> 1.2'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.11'

gem 'thin'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem "bootsnap", ">= 1.1.0", require: false

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

group :development do
  # Use Capistrano for deployment
  # http://capistranorb.com/documentation/getting-started/installation/
  gem 'capistrano-rails', '~> 1.6.1'

  # This gem was added to address an error message provided by ActiveSupport
  # 5.1.4.
  gem 'listen'

  gem 'guard'
  gem 'guard-minitest'
end

# Use debugger
# gem 'debugger', group: [:development, :test]

# https://github.com/svenfuchs/rails-i18n
gem 'rails-i18n', '~> 7.0.1'

# https://github.com/plataformatec/simple_form
gem 'simple_form', '~> 5.1'

# https://github.com/plataformatec/devise
# http://railscasts.com/episodes/209-introducing-devise
# Used for authentication and access control
gem 'devise', '~> 4.8'

# https://github.com/tigrish/devise-i18n
# https://github.com/plataformatec/devise/wiki/I18n
# Used for l18n of devise
gem 'devise-i18n'

gem 'active_model_serializers', '~> 0.10.12'

# Rails 5.0 has removed `assigns` in controllers test and extracted the
# functionality to a gem.
gem 'rails-controller-testing'
