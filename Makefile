RUBY_VERSION = 2.3.1

osx: ruby-packages provisioning-profile-quicklook fish
	defaults write com.apple.screencapture location ~/Downloads/
	killall SystemUIServer
	./link-dotfiles.sh

homebrew:
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew tap Homebrew/bundle
	brew bundle

ruby-packages: homebrew
	brew install rbenv
	rbenv init
	rbenv install $(RUBY_VERSION)
	rbenv global $(RUBY_VERSION)
	~/.rbenv/shims/gem install bundle
	~/.rbenv/shims/bundle install

provisioning-profile-quicklook: homebrew
	brew cask install provisioning
	defaults write com.apple.finder QLEnableTextSelection -bool TRUE
	killall Finder

fish: homebrew
	brew install fish
	brew tap caskroom/fonts
	brew cask font-fontawesome
	brew cask font-hack
	chsh -s /usr/local/bin/fish
	curl -L https://github.com/oh-my-fish/oh-my-fish/raw/master/bin/install
	omf install bobthefish
