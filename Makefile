XCODE_VERSION = 7.3.1

osx: rbenv carthage provisioning-profile-quicklook fish screenshots link-dotfiles

rbenv: homebrew
	intialise_rbenv.sh

homebrew:
	./install_brew.sh
	brew tap Homebrew/bundle
	brew update
	brew bundle
	cp -f com.apple.dock.plist ~/Library/Preferences/com.apple.dock.plist
	killall dock

carthage: xcode homebrew
	brew install carthage

xcode: ruby-packages
	xcversion install $(XCODE_VERSION)

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
	./link_dotfiles.sh
