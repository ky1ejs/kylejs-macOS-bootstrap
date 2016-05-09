RUBY_VERSION = 2.3.1

osx: ruby-packages provisioning-profile-quicklook fish screenshots link-dotfiles

homebrew:
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew tap Homebrew/bundle
	brew bundle
	cp -f com.apple.dock.plist ~/Library/Preferences/com.apple.dock.plist
	killall dock

ruby-packages: homebrew
	eval "$(rbenv init -)"
	rbenv install $(RUBY_VERSION)
	rbenv global $(RUBY_VERSION)
	rbenv rehash
	~/.rbenv/shims/gem install bundle
	rbenv rehash
	~/.rbenv/shims/bundle install

provisioning-profile-quicklook: homebrew
	defaults write com.apple.finder QLEnableTextSelection -bool TRUE
	killall Finder

fish: homebrew
	chsh -s /usr/local/bin/fish
	curl -L https://github.com/oh-my-fish/oh-my-fish/raw/master/bin/install | fish
	omf install bobthefish

screenshots:
	defaults write com.apple.screencapture location ~/Downloads/
	killall SystemUIServer

link-dotfiles:
	./link-dotfiles.sh
