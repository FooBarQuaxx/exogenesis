require 'exogenesis/support/passenger'

# Install Python and pip packages
# REQUIRES: Homebrew (so put it after your homebrew task)
class Python < Passenger
  def_delegator :@config, :pips

  def setup
    executor.execute "Install Python", "brew install python" do |output|
      raise TaskSkipped.new("Already installed") if output.include? "already installed"
    end
    executor.execute "Link Python", "brew link --overwrite python"
  end

  def install
    pips.each do |package|
      executor.execute "Install #{package}", "pip install --user #{package}" do |output|
        raise TaskSkipped.new("Already installed") if output.include? "already satisfied"
      end
    end
  end

  def update
    pips.each do |package|
      executor.execute "Update #{package}", "pip install --user --upgrade #{package}" do |output|
        raise TaskSkipped.new("Already up to date") if output.include? "already up-to-date"
      end
    end
  end
end
