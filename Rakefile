require 'rake'
require_relative 'lib/environment/dotfiles.rb'
require_relative 'lib/environment/vim.rb'
require_relative 'lib/environment/vim/plugins.rb'
require_relative 'lib/environment/shell.rb'

desc "Install dotfiles and related libraries"
task install: %w(dotfiles:install shell:install vim:install)

desc "Update dotfiles and related libraries"
task update: %w(dotfiles:update shell:update vim:update)

task default: :update

namespace :dotfiles do
  desc "Install dotfiles"
  task :install do
    Environment::Dotfiles.new(path: ENV['DOTFILES']).install
  end

  desc "Update dotfiles"
  task :update do
    Environment::Dotfiles.new(path: ENV['DOTFILES']).update
  end
end

namespace :vim do
  desc "Install Janus and vim plugins"
  task :install do
    Environment::Vim.new.install
    Environment::Vim::Plugins.new.install
  end

  desc "Update Janus and vim plugins"
  task :update do
    Environment::Vim.new.update
    Environment::Vim::Plugins.new.update
  end
end

namespace :shell do
  desc "Install Oh-My-Zsh and change default shell"
  task :install do
    Environment::Shell.new.install
    Environment::Shell.new.setup
  end

  desc "Update Oh-My-Zsh"
  task :update do
    Environment::Shell.new.update
  end
end
