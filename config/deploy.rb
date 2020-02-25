# Config valid for current version and patch releases of Capistrano
lock '~> 3.11.0'

set :application, 'kivach-api'
set :repo_url, 'git@gitlab.com:trinity-digital/kivach/kivach-recipes/kivach-recipes-api.git'

set :user, fetch(:application)
set :deploy_to, "/home/#{fetch(:user)}"
set :deploy_via, :remote_cache

set :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :linked_files, %w[.rails-env config/database.yml]
set :linked_dirs, %w[bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system import]

set :rails_env, 'production'

set :slack_fields, %w[stage branch]

namespace :deploy do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/log #{shared_path}/tmp/sockets #{shared_path}/tmp/pids"
    end
  end

  desc 'Runs rake db:seed for SeedMigrations data'
  task seed: [:set_rails_env] do
    on primary fetch(:migration_role) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:seed'
        end
      end
    end
  end

  desc 'Make sure local git is in sync with remote.'
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/#{fetch(:branch)}`
        puts "WARNING: HEAD is not the same as origin/#{fetch(:branch)}"
        puts 'Run `git push` to sync changes.'
        abort
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:restart'
      invoke 'deploy'
    end
  end

  before :starting, :version_update do
    set :version_update, ENV['version'] || 'none'
    case fetch(:version_update)
    when 'none'
      next
    when 'patch', 'minor', 'major'
      Rake::Task.invoke("version:#{fetch(:version_update)}")
    else
      raise "Please choose either 'none', patch', 'minor', 'major' for version_update."
    end
  end

  before :starting, :make_dirs
  after :finishing, :cleanup
end

namespace :sidekiq do
  task :restart do
    invoke 'sidekiq:stop'
    invoke 'sidekiq:start'
  end

  before 'deploy:finished', 'sidekiq:restart'

  task :stop do
    on roles(:app) do
      within current_path do
        # pid = p capture "ps aux | grep sidekiq | awk '{print $2}' | sed -n 1p"
        execute('pgrep --full "^sidekiq .+" | xargs -r kill')
      end
    end
  end

  task :start do
    on roles(:app) do
      within current_path do
        # execute :bundle, "exec sidekiq -e #{fetch(:stage)} -C config/sidekiq.yml -d"
      end
    end
  end
end
