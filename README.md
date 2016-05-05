## OS X Bootstrap

Some people call these kind of repos `username/Dotfiles`, but they usually contain a lot more than just Dotfiles.

This repo contains my Dotfiles and command line tools and applications that I have installed on my mac.

### Usage

```shell
git clone git@github.com:kylejm/kylejm-osx-bootstrap.git ~/Developer/kylejm-osx-bootstrap
cd ~/Developer/kylejm-osx-boostrap
make osx
```

### Things to configure that aren't here

- SSH
- App Store purchases
- [Fabric](https://fabric.io)
- MS Office

### TODO

- [ ] Add tests
- [ ] Improve link-dotfiles.sh to handle backing/deleting existing files in the `~/` dir
- [ ] Error handling for all steps (e.g. `brew bundle` failures)
- [ ] Create homebrew formula for [Helium](https://github.com/JadenGeller/Helium)
- [ ] Write OS X defaults script ([example 1](https://gist.github.com/meleyal/5890865), [example 2](https://github.com/josh-/dotfiles/blob/master/osx))
