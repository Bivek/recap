# `tomafro-deploy` isn't intended to be compatible with tasks (such as those within the `bundler`
# or `whenever` projects) that are built on the original capistrano deployment recipes.  At times
# though there are tasks that would work, but for some missing (and redundant) settings.  
#
# Including this recipe adds these legacy settings, but provides no guarantee that original tasks
# will work.  Many are based on assumptions about the deployment layout that no longer hold true.

Capistrano::Configuration.instance(:must_exist).load do
  extend Tomafro::Deploy::CapistranoExtensions

  # As `git` to manages releases, all deployments are placed directly in the `deploy_to` folder.  The
  # `current_path` is always this directory (no symlinking required).
  set(:current_path) { deploy_to }
end