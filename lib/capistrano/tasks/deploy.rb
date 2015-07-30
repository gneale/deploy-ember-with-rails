# https://gist.github.com/twetzel/66de336327f79beac0e0
# Clear existing task so we can replace it rather than "add" to it.
Rake::Task["deploy:compile_assets"].clear

namespace :deploy do

  desc 'Compile assets'
  task :compile_assets => [:set_rails_env] do
    # invoke 'deploy:assets:precompile'
    invoke 'deploy:assets:precompile_local'
    invoke 'deploy:assets:backup_manifest'
  end

  namespace :assets do
    desc "Precompile assets locally and then rsync to web servers"

    ember_app_name = "ember-app"
    local_dir = "./public/assets/"
    ember_assets_dir = "./#{ember_app_name}/dist/assets/images/"

    task :precompile_local do
      # compile assets locally
      run_locally do
        execute "cd #{ember_app_name} && ember build --environment=production"
        execute "RAILS_ENV=#{fetch(:stage)} bundle exec rake assets:precompile"
      end

      # rsync to each server
      on roles( fetch(:assets_roles, [:web]) ) do
        # this needs to be done outside run_locally in order for host to exist
        remote_assets_dir = "#{host.user}@#{host.hostname}:#{release_path}/public/assets/"
        remote_ember_dir = "#{host.user}@#{host.hostname}:#{release_path}/public/assets/#{ember_app_name}/images/"

        run_locally { execute "rsync -av --delete #{local_dir} #{remote_assets_dir}" }
        run_locally { execute "rsync -av --delete #{ember_assets_dir} #{remote_ember_dir}" }
      end

      # clean up
      run_locally { execute "rm -rf #{local_dir}" }
    end
  end
end
