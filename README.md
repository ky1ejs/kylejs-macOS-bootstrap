## macOS Bootstrap
[![Build Status](https://travis-ci.org/ky1ejs/kylejs-macOS-bootstrap.svg?branch=master)](https://travis-ci.org/ky1ejs/kylejs-macOS-bootstrap)

Some people call these kind of repos `username/Dotfiles`, but they usually contain a lot more than just Dotfiles.

This repo contains my Dotfiles and command line tools and applications that I have installed on my mac.

### Usage

```shell
git clone git@github.com:ky1ejs/kylejs-macOS-bootstrap.git ~/Developer/kylejs-macOS-bootstrap
cd ~/Developer/kylejs-macOS-boostrap
./bootstrap.sh
```

### Things to configure that aren't here

- SSH
- GPG
- Local git configs
- App Store purchases

### Apps that aren't installed here
- BetterSnapTool
- Copilot
- Day One
- Discord
- Logi Bolt
- Lunar
- Parcel

### TODO

- [ ] Add tests
- [ ] Improve link-dotfiles.sh to handle backing/deleting existing files in the `~/` dir
- [ ] Error handling for all steps (e.g. `brew bundle` failures)
- [ ] Create homebrew formula for [Helium](https://github.com/JadenGeller/Helium)
- [ ] Write macOS defaults script ([example 1](https://gist.github.com/meleyal/5890865), [example 2](https://github.com/josh-/dotfiles/blob/master/osx))
