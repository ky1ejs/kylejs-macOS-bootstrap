XCODE_VERSION = 7.3.1

osx: rbenv carthage provisioning-profile-quicklook fish screenshots dock link-dotfiles

rbenv: homebrew
	./initialise_rbenv.sh

homebrew:
	./install_brew.sh
	brew tap Homebrew/bundle
	brew update
	brew bundle

carthage: xcode homebrew
	brew install carthage

xcode: rbenv
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

dock:
	configure_dock.sh

link-dotfiles:
	./link_dotfiles.sh
