FILE_PATH=$(dirname $(realpath $0))
FILES_PATH=$FILE_PATH/../files
ZSHRC_TEMPLATE=$FILES_PATH/.zshrc
ALIAS_FILE='$HOME/Projects/sysadmin/utils/alias/.self_profile'

# Install pre-requisites.
sudo apt install git curl zsh -y

# As ROOT
sudo su

# Install OH MY ZSH in /opt/
export ZSH="/opt/oh-my-zsh"; sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Spaceship prompt
git clone "https://github.com/denysdovhan/spaceship-prompt.git" "$ZSH/custom/themes/spaceship-prompt" 
ln -s "$ZSH/custom/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH/themes/spaceship.zsh-theme"

# Syntax highlight
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /opt/zsh-syntax-highlighting
echo "source /opt/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

# Change the shell of the root user
chsh -s $(which zsh)

exit

# Change the shell of your user
chsh -s $(which zsh) $USER

# Update the theme to spaceship and place the values:
nano ~/.zshrc

# Copy the zshrc to the user and check
cp $ZSHRC_TEMPLATE $HOME/.zshrc
chown $USER:$USER $HOME/.zshrc

# Load alias.
echo "source $ALIAS_FILE" >> $HOME/.zshrc

echo -e "\n\nClose session and return. See you soon..."