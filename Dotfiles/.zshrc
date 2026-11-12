export PATH=/usr/local/bin:/opt/homebrew/bin:$PATH


# bun completions
[ -s "/Users/kylejs/.bun/_bun" ] && source "/Users/kylejs/.bun/_bun"

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
