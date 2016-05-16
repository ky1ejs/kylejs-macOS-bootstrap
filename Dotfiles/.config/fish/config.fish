# Path to Oh My Fish install.
set -gx OMF_PATH "/Users/kylejm/.local/share/omf"

# Customize Oh My Fish configuration path.
#set -gx OMF_CONFIG "/Users/kylejm/.config/omf"

# Load oh-my-fish configuration.
source $OMF_PATH/init.fish

set PATH $HOME/.rbenv/shims $HOME/bin $PATH
rbenv init - | source
