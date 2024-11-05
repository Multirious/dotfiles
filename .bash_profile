# This script is part of an attempt to
# standardize shell configurations

# We need to do two things here:

# 1. Ensure ~/.config/bash/env gets run first
. ~/.config/bash/env

# 2. Prevent it from being run later, since we need to use $BASH_ENV for
# non-login non-interactive shells.
# We don't export it, as we may have a non-login non-interactive shell as
# a child.
BASH_ENV=

# 3. Join the spanish inquisition. ;)
# so much for only two things...

# 4. Run ~/.config/bash/login
. ~/.config/bash/login

# 5. Run ~/.config/bash/interactive if this is an interactive shell.
if [ "$PS1" ]; then
  . ~/.config/bash/interactive
fi

