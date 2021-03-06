#!/bin/sh

sudo apt-get install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
zsh

########## Variables  

dir=~/dotfiles                    		# dotfiles directory 
olddir=~/dotfiles_old             		# old dotfiles backup directory 
files=".bashrc .profile .zshrc"     # list of files/folders to symlink in homedir  

##########  

sudo apt-get update

# Shells
sudo apt-get install -y zsh fish python3-dev python3-pip
sudo -H pip3 install thefuck
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# create dotfiles_old in homedir 
echo "Creating $olddir for backup of any existing dotfiles in ~" 
mkdir -p $olddir 
echo "...done"  

# change to the dotfiles directory 
echo "Changing to the $dir directory" 
cd $dir 
echo "...done"  

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do     
    echo "Moving any existing dotfiles from ~ to $olddir"     
    mv ~/$file ~/dotfiles_old/     
    echo "Creating symlink to $file in home directory."     
    ln -s $dir/$file ~/$file 
done  

source ~/.bashrc 

# Handle fish.config
mv ~/.config/fish/config.fish ~/dotfiles_old/     
ln -s ~/$dir/fish.config ~/.config/fish/config.fish

# VIM
curl -sLf https://spacevim.org/install.sh | bash
source ~/.vimrc

# Themes
sudo wget https://raw.githubusercontent.com/marszall87/nodeys-zsh-theme/master/nodeys.zsh-theme
mv  nodeys.zsh-theme ~/.oh-my-zsh/themes

# NodeJS
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs
