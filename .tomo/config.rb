plugin "git"
plugin "env"
plugin "bundler"
plugin "rails"
plugin "nodenv"
plugin "puma"
plugin "rbenv"
plugin "./plugins/aggregatorapp.rb"
plugin "sidekiq"

host "deploy@143.198.215.255"

set application: "aggregatorapp"
set deploy_to: "/var/www/%{application}"
set rbenv_ruby_version: "3.2.1"
set nodenv_node_version: "18.15.0"
set nodenv_install_yarn: true
set git_url: "https://github.com/shfkahariff/aggregatorapp.git"
set git_branch: "main"
set git_exclusions: %w[
  .tomo/
  spec/
  test/
]
set env_vars: {
  RACK_ENV: "production",
  RAILS_ENV: "production",
  RAILS_LOG_TO_STDOUT: "1",
  RAILS_SERVE_STATIC_FILES: "1",
  RUBY_YJIT_ENABLE: "1",
  BOOTSNAP_CACHE_DIR: "tmp/bootsnap-cache",
  DATABASE_URL: "postgresql://deploy:wlk123@127.0.0.1/aggregatorapp",
  SECRET_KEY_BASE: :prompt
}
set linked_dirs: %w[
  .yarn/cache
  log
  node_modules
  public/assets
  public/packs
  public/vite
  tmp/cache
  tmp/pids
  tmp/sockets
]

set linked_files: %w[
  config/master.key
  config/credentials/production.key
  config/database.yml
]

setup do
  run "env:setup"
  run "core:setup_directories"
  run "git:clone"
  run "git:create_release"
  run "core:symlink_shared"
  run "bundler:upgrade_bundler"
  run "bundler:config"
  run "bundler:install"
  run "puma:setup_systemd"
  run "sidekiq:setup_systemd"
end

deploy do
  run "env:update"
  run "git:create_release"
  run "core:symlink_shared"
  run "core:write_release_json"
  run "bundler:install"
  run "rails:db_create"
  run "rails:db_migrate"
  run "rails:assets_precompile"
  run "core:symlink_current"
  run "puma:restart"
  run "puma:check_active"
  run "core:clean_releases"
  run "bundler:clean"
  run "core:log_revision"
  run "sidekiq:restart"
end
