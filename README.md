# rails-template

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install openssl cmake postgres
curl -sSL https://get.rvm.io | bash -s stable
rvm install 2.5.1 --default --with-openssl-dir=`brew --prefix openssl`
gem install rails
rails new cool_app --skip-coffee -f -B -d postgresql -m https://raw.githubusercontent.com/seouri/rails-template/master/template.rb
cd cool_app
gem update bundler
gem install nokogiri -- --use-system-libraries=true --with-xml2-include=`xcrun --show-sdk-path`/usr/include/libxml2
bundle install
```
