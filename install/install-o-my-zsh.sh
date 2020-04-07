#!/bin/sh

FILE_PATH=$(dirname "$(realpath "$0")")
FILES_PATH="$FILE_PATH"/../files
ZSHRC_TEMPLATE="$FILES_PATH"/.zshrc
ALIAS_FILE="$HOME"/Projects/sysadmin/alias/.self_profile
ZSH='/opt/oh-my-zsh'

# Install pre-requisites.
sudo apt install git curl zsh -y

##### Root install ######

# Install OH MY ZSH in /opt/
sudo sh -c "export ZSH=$ZSH CHSH='no' RUNZSH='no' ; $(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Spaceship prompt
sudo git clone "https://github.com/denysdovhan/spaceship-prompt.git" "$ZSH/custom/themes/spaceship-prompt" 
sudo ln -s "$ZSH/custom/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH/themes/spaceship.zsh-theme"

# Syntax highlight
sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /opt/zsh-syntax-highlighting

# Change the shell of the root user
sudo cp $ZSHRC_TEMPLATE /root/.zshrc

# Change the shell of root.
sudo chsh -s $(which zsh) root

##### Finish Root install ######

# Change the shell of your user
chsh -s $(which zsh) $USER

# Copy the zshrc to the user and check
cp $ZSHRC_TEMPLATE $HOME/.zshrc
chown $USER:$USER $HOME/.zshrc

# Load alias.
echo "source $ALIAS_FILE" >> $HOME/.zshrc

echo -e "\n\nClose session and return. See you soon..."
