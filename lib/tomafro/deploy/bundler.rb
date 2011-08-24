# The bundler recipe ensures that the application bundle is installed whenever the code is updated.

Capistrano::Configuration.instance(:must_exist).load do
  # Each bundle is declared in a `Gemfile`, by default in the root of the application directory
  set(:bundle_gemfile) { "#{deploy_to}/Gemfile" }

  # As well as a `Gemfile`, application repositories should also contain a `Gemfile.lock`.
  set(:bundle_gemfile_lock) { "#{bundle_gemfile}.lock" }

  # An application's gems are installed within the application directory.  By default they are
  # places under `.bundle/gems`.
  set(:bundle_dir) { "#{deploy_to}/.bundle/gems" }

  # Not all gems are needed for production environments, so by default the `development`, `test` and
  # `assets` groups are skipped.
  set(:bundle_without) { "development test assets" }

  namespace :bundle do
    namespace :install do
      # After cloning or updating the code, we only install the bundle if the `Gemfile` has changed.
      desc "Install the latest gem bundle only if Gemfile.lock has changed"
      task :if_changed do
        if deployed_file_changed?(bundle_gemfile_lock)
          top.bundle.install
        end
      end

      # Occassionally it's useful to force an install (such as if something has gone wrong in
      # a previous deployment)
      desc "Install the latest gem bundle"
      task :default do
        if deployed_file_exists?(bundle_gemfile)
          bundler "install --gemfile #{bundle_gemfile} --path #{bundle_dir} --deployment --quiet --without #{bundle_without}"
        else
          puts "Skipping bundle:install as no Gemfile found"
        end
      end
    end
  end

  # To install the bundle automatically each time the code is updated or cloned, hooks are added to
  # the `deploy:clone_code` and `deploy:update_code` tasks.
  after 'deploy:clone_code', 'bundle:install:if_changed'
  after 'deploy:update_code', 'bundle:install:if_changed'
end
