lock "~> 3.17.1"

set :application, "AWS_exam"
set :repo_url, "https://github.com/MoekaKitamura/AWS_exam.git"
set :linked_files, %w{config/secrets.yml .env}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets public/uploads}
set :keep_releases, 5
set :rbenv_ruby, '3.0.1'
set :log_level, :info
set :bundle_without, %w{test}.join(':')

after 'deploy:published', 'deploy:seed'
after 'deploy:finished', 'deploy:restart'

namespace :deploy do
  desc 'Run seed'
  task :seed do
    on roles(:db) do
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:seed'
        end
      end
    end
  end
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end
end