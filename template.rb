git :init
git add: "."
git commit: "-a -m 'Initial commit'"

gem_group :development, :test do
  gem "pronto-brakeman", require: false
  gem "pronto-fasterer", require: false
  gem "pronto-flay", require: false
  gem "pronto-rails_best_practices", require: false
  gem "pronto-reek", require: false
  gem "pronto-rubocop", require: false
  gem "pronto-simplecov", require: false
  gem "pronto", require: false
  gem "pry-rails"
end

gem_group :development do
  gem "bullet"
  gem "bundler-audit", require: false
  gem "dotenv-rails"
  gem "letter_opener_web"
  gem "ruby_audit", require: false
end

gem_group :test do
  gem "minitest-ci"
  gem "simplecov", require: false
end

gem "ar-uuid"

# pry-rails gem
file ".pryrc", <<-CODE
if defined?(PryRails::RAILS_PROMPT)
  Pry.config.prompt = PryRails::RAILS_PROMPT
end
CODE

# bullet gem
environment nil, env: "development" do
<<-CODE
config.after_initialize do
  Bullet.enable = true
  Bullet.alert = true
  Bullet.bullet_logger = true
  Bullet.console = true
  Bullet.rails_logger = true
  Bullet.add_footer = true
end
CODE
end

# dotenv-rails gem
file ".env", ""
file ".env.development", ""
file ".env.local", ""
run "echo '.env.local' >> .gitignore"

# minitest-ci gem
run "echo '/test/reports' >> .gitignore"

# letter_opener_web gem
environment "config.action_mailer.delivery_method = :letter_opener_web",
            env: "development"

route <<-CODE
mount LetterOpenerWeb::Engine, at: '/sent_emails' if Rails.env.development?
CODE

file ".rubocop.yml", <<-CODE
Metrics/BlockLength:
  Exclude:
    - 'config/environments/development.rb'

Metrics/LineLength:
  Max: 130

Style/ClassAndModuleChildren:
  Exclude:
    - 'test/test_helper.rb'

Style/Documentation:
  Exclude:
    - 'spec/**/*'
    - 'test/**/*'
    - 'app/helpers/application_helper.rb'
    - 'app/mailers/application_mailer.rb'
    - 'app/models/application_record.rb'
    - 'config/application.rb'

Style/MixinUsage:
  Exclude:
    - 'bin/setup'
    - 'bin/update'
CODE

# simplecov gem
run "echo 'coverage' >> .gitignore"
environment "config.public_file_server.enabled = false",
            env: "test"
environment "config.eager_load = false",
            env: "test"

# rvm
file ".ruby-gemset", "#{app_name}"
run "rvm gemset create #{app_name}"

# CircleCI
file ".circleci/config.yml", <<-CODE
version: 2
jobs:
  build:
    parallelism: 1

    docker:
      - image: circleci/ruby:2.5.1-node-browsers
      - image: circleci/postgres:9.6.9-alpine-ram

    environment:
      RAILS_ENV: "test"
      PGHOST: "localhost"
      PGUSER: "postgres"

    steps:

      - checkout

      - restore_cache:
          keys:
          - gem-cache-{{ .Branch }}-{{ checksum "Gemfile.lock" }}
          - gem-cache-{{ checksum "Gemfile.lock" }}
          - gem-cache

      # For rugged gem (pronto gem dependency)
      - run: sudo apt-get install cmake

      - run:
          name: Bundle Install
          command: bundle check --path=vendor/bundle || bundle install --path=vendor/bundle --jobs=4 --retry=3

      - run:
          name: Ruby Audit
          command: bundle exec ruby-audit check

      - run:
          name: Bundle Audit
          command: bundle exec bundle-audit check --update

      - run:
          name: Brakeman
          command: bundle exec brakeman

      - run:
          name: Rubocop
          command: bundle exec rubocop

      # Store bundle cache
      - save_cache:
          key: gem-cache-{{ .Branch }}-{{ checksum "Gemfile.lock" }}
          paths:
            - vendor/bundle

      - save_cache:
          key: gem-cache-{{ checksum "Gemfile.lock" }}
          paths:
            - vendor/bundle

      - save_cache:
          key: gem-cache
          paths:
            - vendor/bundle

      - run:
          name: Set up DB
          command: bundle exec rails db:setup

      - run:
          name: Rails Test
          command: bundle exec rake test

      - store_test_results:
          path: test/reports
          destination: test-results/rails

      - store_artifacts:
          path: test/reports
          destination: test-results/MiniTest

      - store_artifacts:
          path: coverage
          destination: coverage
CODE

# README
file "README.md", <<-CODE
## Getting Started

1. Install [Homebrew](https://brew.sh/):

    ```sh
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    ```

2. Install OpenSSL libraries:

    ```sh
    brew install openssl
    ```

3. Install RVM and Ruby:

    ```sh
    curl -sSL https://get.rvm.io | bash -s stable
    # In a new session (restart your terminal or open new tab):
    rvm install 2.5.1 --default --with-openssl-dir=`brew --prefix openssl`
    ```

4. Set up RVM gemset:

    ```sh
    rvm gemset create #{app_name}
    rvm use 2.5.1@#{app_name}
    gem update --system
    gem update bundler
    gem install nokogiri -- --use-system-libraries=true --with-xml2-include=`xcrun --show-sdk-path`/usr/include/libxml2
    ```
CODE

after_bundle do
  run "bundle install"
  rails_command("db:create")
  rails_command("db:migrate")
  run "rubocop -a"
  git add: "."
  git commit: "-a -m 'Set up development environment'"
end
