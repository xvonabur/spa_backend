# frozen_string_literal: true
# config valid only for current version of Capistrano
lock "3.8.0"

set :application, 'spa_backend'
set :repo_url, 'git@github.com:xvonabur/spa_backend.git'
set :branch, 'task7'
set :deploy_to, '/home/deploy/applications/spa_backend'

set :log_level, :info
set :linked_files, %w{config/database.yml .env.production}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads}

set :rbenv_type, :user
set :rbenv_ruby, '2.3.3'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_roles, :all

set :puma_init_active_record, true
