# rails-template

## Getting Started

1. Install [Homebrew](https://brew.sh/):

    ```sh
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    ```

2. Install OpenSSL, Cmake, PostgreSQL:

    ```sh
    brew install openssl cmake postgres
    ```

3. Install RVM and Ruby:

    ```sh
    curl -sSL https://get.rvm.io | bash -s stable
    # In a new session (restart your terminal or open new tab):
    rvm install 2.5.1 --default --with-openssl-dir=`brew --prefix openssl`
    ```

4. Set up RVM gemset:

    ```sh
    rvm gemset create cool_app
    rvm use 2.5.1@cool_app
    gem update --system
    gem update bundler
    gem install nokogiri -- --use-system-libraries=true --with-xml2-include=`xcrun --show-sdk-path`/usr/include/libxml2
    gem install rails
    ```

5. Create Rails application:

    ```sh
    rails new cool_app --skip-coffee -f -B -d postgresql -m https://raw.githubusercontent.com/seouri/rails-template/master/template.rb
    ```

## Gems

- [ar-uuid](https://rubygems.org/gems/ar-uuid)
- [bullet](https://rubygems.org/gems/bullet)
- [bundler-audit](https://rubygems.org/gems/bundler-audit)
- [dotenv-rails](https://rubygems.org/gems/dotenv-rails)
- [letter_opener_web](https://rubygems.org/gems/letter_opener_web)
- [minitest-ci](https://rubygems.org/gems/minitest-ci)
- [pronto-brakeman](https://rubygems.org/gems/pronto-brakeman)
- [pronto-fasterer](https://rubygems.org/gems/pronto-fasterer)
- [pronto-flay](https://rubygems.org/gems/pronto-flay)
- [pronto-rails_best_practices](https://rubygems.org/gems/pronto-rails_best_practices)
- [pronto-reek](https://rubygems.org/gems/pronto-reek)
- [pronto-rubocop](https://rubygems.org/gems/pronto-rubocop)
- [pronto-simplecov](https://rubygems.org/gems/pronto-simplecov)
- [pronto](https://rubygems.org/gems/pronto)
- [pry-rails](https://rubygems.org/gems/pry-rails)
- [ruby_audit](https://rubygems.org/gems/ruby_audit)
- [simplecov](https://rubygems.org/gems/simplecov)
