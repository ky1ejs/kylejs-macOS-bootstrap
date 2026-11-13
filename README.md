## macOS Bootstrap
Some people call these kind of repos `username/dotfiles`, but they usually contain a lot more than just dotfiles.

This repo contains my dotfiles, command line tools, applications and various configuration I use on my mac.

### Usage

```shell
git clone git@github.com:ky1ejs/kylejs-macOS-bootstrap.git ~/Developer/kylejs-macOS-bootstrap
cd ~/Developer/kylejs-macOS-bootstrap
./install.sh
```

#### Dotfiles only

On a Mac that is set up some other way (the homelab Mac Studio is configured by nix-darwin from [ky1ejs/homelab](https://github.com/ky1ejs/homelab)), link the dotfiles and `bin/` without installing apps or changing macOS settings:

```shell
./link.sh
```

The links point into the checkout, so the same files serve every Mac. Edit them on either machine, commit, and `git pull` on the other. Each machine's `~/.config/git/config.local` holds what differs, such as `user.email`, or `[commit] gpgsign = false` where there is no signing key.

#### SSH to the homelab

`Dotfiles/.config/ssh/config` defines `ssh nas` and `ssh ms` (the Mac Studio). Each one uses the tailnet name while Tailscale is connected and the LAN address while it is not. `~/.ssh/config` stays per machine, and is not linked, because `~/.ssh` also holds `known_hosts`. To use the shared hosts, put this line at the top of it, above any `Host *`:

```
Include ~/.config/ssh/config
```

### Things to do before running the install script

- Install Xcode ([here](https://developer.apple.com/download/applications/))
- Install and set up [1Password](https://1password.com/downloads/mac/)

### Apps that aren't installed here
- Copilot
- Day One
- Discord
- Logictech MX Master App
- Parcel
- Lightroom
