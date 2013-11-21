require 'rake'
require 'fileutils'
require File.join(File.dirname(__FILE__), 'bin', 'vundle')

desc "Hook our dotfiles into system-standard positions."
task :install => [:submodule_init, :submodules] do
  puts
  puts "======================================================"
  puts "Welcome to DotFiles Installation."
  puts "======================================================"
  puts

  install_homebrew if RUBY_PLATFORM.downcase.include?("darwin")
  install_rvm_binstubs

  # this has all the runcoms from this directory.
  file_operation(Dir.glob('git/*')) if want_to_install?('git configs (color, aliases)')
  file_operation(Dir.glob('irb/*')) if want_to_install?('irb/pry configs (more colorful)')
  file_operation(Dir.glob('ruby/*')) if want_to_install?('rubygems config (faster/no docs)')
  file_operation(Dir.glob('bash/*')) if want_to_install?('bash config (bash files and better js/ruby support)')
  if want_to_install?('vim configuration (highly recommended)')
    file_operation(Dir.glob('{vim,vimrc}'))
    Rake::Task["install_vundle"].execute
  end

  install_fonts if RUBY_PLATFORM.downcase.include?("darwin")

  success_msg("installed")
end

task :update do
  Rake::Task["vundle_migration"].execute if needs_migration_to_vundle?
  Rake::Task["install"].execute
  #TODO: for now, we do the same as install. But it would be nice
  #not to clobber zsh files
end

task :submodule_init do
  unless ENV["SKIP_SUBMODULES"]
    run %{ git submodule update --init --recursive }
  end
end

desc "Init and update submodules."
task :submodules do
  unless ENV["SKIP_SUBMODULES"]
    puts "======================================================"
    puts "Downloading DotFiles submodules...please wait"
    puts "======================================================"

    run %{
      cd $HOME/.dotfiles
      git submodule update --recursive
      git clean -df
    }
    puts
  end
end

desc "Performs migration from pathogen to vundle"
task :vundle_migration do
  puts "======================================================"
  puts "Migrating from pathogen to vundle vim plugin manager. "
  puts "This will move the old .vim/bundle directory to"
  puts ".vim/bundle.old and replacing all your vim plugins with"
  puts "the standard set of plugins. You will then be able to "
  puts "manage your vim's plugin configuration by editing the "
  puts "file .vim/vundles.vim"
  puts "======================================================"

  Dir.glob(File.join('vim', 'bundle','**')) do |sub_path|
    run %{git config -f #{File.join('.git', 'config')} --remove-section submodule.#{sub_path}}
    # `git rm --cached #{sub_path}`
    FileUtils.rm_rf(File.join('.git', 'modules', sub_path))
  end
  FileUtils.mv(File.join('vim','bundle'), File.join('vim', 'bundle.old'))
end

desc "Runs Vundle installer in a clean vim environment"
task :install_vundle do
  puts "======================================================"
  puts "Installing vundle."
  puts "The installer will now proceed to run BundleInstall."
  puts "Due to a bug, the installer may report some errors"
  puts "when installing the plugin 'syntastic'. Fortunately"
  puts "Syntastic will install and work properly despite the"
  puts "errors so please just ignore them and let's hope for"
  puts "an update that fixes the problem!"
  puts "======================================================"

  puts ""

  run %{
    cd $HOME/.dotfiles
    git clone https://github.com/gmarik/vundle.git #{File.join('vim','bundle', 'vundle')}
  }

  Vundle::update_vundle
end

task :default => 'install'


private
def run(cmd)
  puts "[Running] #{cmd}"
  `#{cmd}` unless ENV['DEBUG']
end

def install_rvm_binstubs
  puts "======================================================"
  puts "Installing RVM Bundler support. Never have to type"
  puts "bundle exec again! Please use bundle --binstubs and RVM"
  puts "will automatically use those bins after cd'ing into dir."
  puts "======================================================"
  run %{ chmod +x $rvm_path/hooks/after_cd_bundler }
  puts
end

def install_homebrew
  run %{which brew}
  unless $?.success?
    puts "======================================================"
    puts "Installing Homebrew, the OSX package manager...If it's"
    puts "already installed, this will do nothing."
    puts "======================================================"
    run %{ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"}
  end

  puts
  puts
  puts "======================================================"
  puts "Updating Homebrew."
  puts "======================================================"
  run %{brew update}
  puts
  puts
  puts "======================================================"
  puts "Installing Homebrew packages...There may be some warnings."
  puts "======================================================"
  run %{brew install zsh ctags git hub tmux reattach-to-user-namespace the_silver_searcher}
  puts
  puts
end

def install_fonts
  puts "======================================================"
  puts "Installing patched fonts for Powerline."
  puts "======================================================"
  run %{ cp -f $HOME/.dotfiles/fonts/* $HOME/Library/Fonts }
  puts
end

def ask(message, values)
  puts message
  while true
    values.each_with_index { |val, idx| puts " #{idx+1}. #{val}" }
    selection = STDIN.gets.chomp
    if (Float(selection)==nil rescue true) || selection.to_i < 0 || selection.to_i > values.size+1
      puts "ERROR: Invalid selection.\n\n"
    else
      break
    end
  end
  selection = selection.to_i-1
  values[selection]
end

def want_to_install? (section)
  if ENV["ASK"]=="true"
    puts "Would you like to install configuration files for: #{section}? [y]es, [n]o"
    STDIN.gets.chomp == 'y'
  else
    true
  end
end

def file_operation(files, method = :symlink)
  files.each do |f|
    file = f.split('/').last
    source = "#{ENV["PWD"]}/#{f}"
    target = "#{ENV["HOME"]}/.#{file}"

    puts "======================#{file}=============================="
    puts "Source: #{source}"
    puts "Target: #{target}"

    if File.exists?(target) && (!File.symlink?(target) || (File.symlink?(target) && File.readlink(target) != source))
      puts "[Overwriting] #{target}...leaving original at #{target}.backup..."
      run %{ mv "$HOME/.#{file}" "$HOME/.#{file}.backup" }
    end

    if method == :symlink
      run %{ ln -nfs "#{source}" "#{target}" }
    else
      run %{ cp -f "#{source}" "#{target}" }
    end

    puts "=========================================================="
    puts
  end
end

def needs_migration_to_vundle?
  File.exists? File.join('vim', 'bundle', 'tpope-vim-pathogen')
end


def list_vim_submodules
  result=`git submodule -q foreach 'echo $name"||"\`git remote -v | awk "END{print \\\\\$2}"\`'`.select{ |line| line =~ /^vim.bundle/ }.map{ |line| line.split('||') }
  Hash[*result.flatten]
end

def success_msg(action)
  puts ""
  puts "   _     _           _         "
  puts "  | |   | |         | |        "
  puts "  | |___| |_____  __| | ____   "
  puts "  |_____  (____ |/ _  |/ ___)  "
  puts "   _____| / ___ ( (_| | |      "
  puts "  (_______\_____|\____|_|      "
  puts ""
  puts "DotFiles has been #{action}. Please restart your terminal and vim."
end
