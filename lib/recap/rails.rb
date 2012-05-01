# Require `recap/rails` in your `Capfile` to use the default recap recipies for deploying a
# Rails application.
require 'recap/tasks/deploy'

module Recap::Rails
  extend Recap::Support::Namespace

  # Requiring this file will create tasks with the appropriate hooks to run migrations
  # if any changes are detected in `db/schema.rb`.
  namespace :rails do
    namespace :db do
      task :load_schema do
        if deployed_file_exists?("db/schema.rb")
          as_app './bin/rake db:create db:schema:load'
        end
      end

      task :migrate do
        if deployed_file_changed?("db/schema.rb")
          as_app './bin/rake db:migrate'
        end
      end
    end

    after "deploy:clone_code", "rails:db:load_schema"
    after "deploy:update_code", "rails:db:migrate"
  end
end
