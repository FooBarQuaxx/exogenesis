require 'exogenesis/support/passenger'

# Manages the Vim Package Manager Vundle
class Vundle < Passenger
  VUNDLE_REPO = "git://github.com/gmarik/vundle.git"

  # The dependencies are read from your Vim files
  # It creates a `~/.vim` folder and clones Vundle.
  def setup
    executor.create_path_in_home ".vim", "bundle", "vundle"
    executor.execute "Cloning Vundle", "git clone #{VUNDLE_REPO} #{vundle_folder}" do |output, error_output|
      raise TaskSkipped.new("Already exists") if error_output.include? "already exists"
    end
  end

  # Runs BundleInstall in Vim
  def install
    executor.execute_interactive "Install", "vim +BundleInstall\! +qall"
    executor.execute_interactive "Clean", "vim +BundleClean\! +qall"
  end

  # Removes the ~/.vim folder
  def teardown
    executor.execute "Removing Vim Folder", "rm -r #{vim_folder}" do |output|
      raise TaskSkipped.new("Folder not found") if output.include? "No such file or directory"
    end
  end

  # Updates all installed vundles
  def update
    executor.execute_interactive "Updating Vim Bundles", "vim +BundleUpdate +qall"
  end

  # Runs BundleClean in Vim
  def cleanup
    executor.execute_interactive "Cleaning", "vim +BundleClean\! +qall"
  end

  private

  def vim_folder
    executor.get_path_in_home ".vim"
  end

  def vundle_folder
    executor.create_path_in_home ".vim", "bundle", "vundle"
  end
end
