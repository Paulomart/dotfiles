#! /usr/bin/env zsh

if [ "$(uname)" != "Darwin" ]
then
    echo "Aborting. These dotfiles are meant to be running on macOS"
    exit 1
fi

REPO_NAME=".files"
CURRENT_PATH=$(pwd)
DOTFILES_PATH="${CURRENT_PATH}/${REPO_NAME}"
DOTFILES_PATH="${DOTFILES_PATH}/dotfiles"

# Install applications
if [ ! -f "$(which brew)" ]
then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

BREW_FORMULA=(
    git
    gh
    htop
    fish
    mas
    nvm
    jabba
    pyenv
    pritunl
    wget
    z
)

BREW_CASKS=(
    1password
    bitwarden
    caffeine
    db-browser-for-sqlite
    discord
    docker
    firefox
    vivaldi
    google-chrome
    iterm2
    microsoft-teams
    telegram-desktop
    visual-studio-code
    vmware-fusion
)

brew install $BREW_FORMULA
brew install --cask $BREW_CASKS

compaudit | xargs chmod g-w

# Setup
mkdir "~/dev"
mkdir "~/.ssh"

git clone git://github.com/paulomart/dotfiles.git $REPO_NAME
git config --global core.excludesfile '~/.gitignore'
git config --global pull.rebase true
git config --global init.defaultBranch master
git config --global advice.statusHints false

code --install-extension bungcip.better-toml
code --install-extension mikestead.dotenv
code --install-extension editorconfig.editorconfig
code --install-extension dbaeumer.vscode-eslint
code --install-extension eamodio.gitlens
code --install-extension oderwat.indent-rainbow
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
code --install-extension esbenp.prettier-vscode
code --install-extension vscode-icons-team.vscode-icons
code --install-extension redhat.vscode-yaml

ln -sf "${DOTFILES_PATH}/git/.gitignore" $HOME

defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write -g ApplePressAndHoldEnabled -bool false

defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Setup venv manually
# cd ~/5Minds/${REPO_NAME}/FlappyBird && python3 -m venv venv && source ./venv/bin/activate && pip3 install pygame &&

# Finish
echo "You may still want to configure the following things:"
echo "  - Request password after lock immediately"
echo "  - Run: 'compaudit | xargs chmod g-w' if there are insecure directories"
echo "Reboot."
