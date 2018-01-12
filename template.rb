git :init
git add: "."
git commit: "-a -m 'Initial commit'"

run "bundle config build.nokogiri --use-system-libraries"

gem_group :development, :test do
  gem "pronto"
  gem "pronto-brakeman", require: false
  gem "pronto-flay", require: false
  gem "pronto-reek", require: false
  gem "pronto-rubocop", require: false
  gem "pronto-simplecov", require: false
  gem "pry-rails"
end

gem_group :development do
  # gem "bullet"
  gem "bundler-audit", require: false
  gem "dotenv-rails"
  gem "letter_opener_web"
  gem "rubocop-rails"
  gem "ruby_audit", require: false
end

gem_group :test do
  gem "simplecov", require: false
end

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

# letter_opener_web gem
environment "config.action_mailer.delivery_method = :letter_opener_web",
            env: "development"

route <<-CODE
if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/sent_emails"
end
CODE

# rubocop-rails gem 
file ".rubocop.yml", <<-CODE
  inherit_gem:
    rubocop-rails:
      - config/rails.yml
CODE

# simplecov gem
run "echo 'coverage' >> .gitignore"
environment "config.public_file_server.enabled = false",
            env: "test"
environment "config.eager_load = false",
            env: "test"

# rvm
file ".ruby-gemset", "#{app_name}"
file ".ruby-version", "2.4.2"

after_bundle do
  rails_command("db:create")
  rails_command("db:migrate")
  run "rubocop -a"
  git add: "."
  git commit: "-a -m 'Set up development gems'"
end
