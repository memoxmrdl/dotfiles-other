module Environment
  class Dotfiles
    include Environment::Utils

    attr_reader :path

    UPDATE_COMMAND = 'git pull origin master'
    EXCLUDED_FILES = %w(Rakefile README.md zsh vim tmux gem screenshots lib)

    def initialize(options = {})
      @path = options.fetch('path') do
        File.join(ENV.fetch('HOME'), 'workspace', 'dotfiles')
      end
    end

    def install
      say "Installing dotfiles"

      overwrite_all = false
      backup_all    = false

      dotfiles = Dir.glob('*') - EXCLUDED_FILES

      dotfiles.each do |dotfile|
        overwrite = false
        backup    = false
        target    = dotfile_target_for(dotfile)

        if File.exists?(target) || File.symlink?(target)
          unless overwrite_all || backup_all
            prompt "File already exists: #{target}, what do you want to do? " \
              "[s]kip [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all"

            case STDIN.gets.chomp
            when 'o' then overwrite     = true
            when 'b' then backup        = true
            when 'O' then overwrite_all = true
            when 'B' then backup_all    = true
            when 's' then next
            end
          end

          backup_file(target) if backup || backup_all
        end

        link_file(dotfile, target)
      end
    end

    def update
      say "Updating dotfiles"

      if File.exists?(path)
        system %{cd "#{path}" && #{UPDATE_COMMAND}}
      else
        say "DOTFILES does not exist", :error
      end
    end

    private

    def dotfile_target_for(dotfile)
      File.join(ENV.fetch('HOME'), dotfile_format_for(dotfile))
    end

    def dotfile_format_for(dotfile)
      ".#{dotfile}"
    end
  end
end
