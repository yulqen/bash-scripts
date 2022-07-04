#!/bin/ksh

# Send in id_rsa.pub and id_rsa
# send in /etc/doas.conf and install and chown root:wheel /etc/doas.conf
# pkg_add git in guest
# send in openbsddotfiles/profile_vm_provisioning (or similar) and rename to .profile
# source .profile in guest
# send in THIS FILE AND EXECUTE IT ON THERE

# download ISO from https://cdn.openbsd.org/pub/OpenBSD/$(uname -r)/amd64/install71.iso

INC_CODE=0


usage()
{
  print "Usage: $0 [-c]"
  exit 2
}

while getopts 'ch' opt
do
  case $opt in
    c) INC_CODE=1; print "Will fetch code from github." ;;
    h) usage ;; 
    ?) usage ;; 
  esac
done



command -v vim > /dev/null 2>&1
if [ "$?" != 0 ]; then
  doas pkg-add vim
fi


doas pkg_add fzf the_silver_searcher zip 

if [ $INC_CODE -eq 1 ]; then
  ssh-add -v
  print -n "Creating necessary directories..."
  mkdir -p ~/code/python
  mkdir -p ~/.config/
  mkdir -p ~/.fzf/
  print "ok"

  print -n "Fetching dotfiles..."
  if [ ! -d ~/openbsddotfiles ]; then
    git clone git@github.com:yulqen/openbsddotfiles.git ~/openbsddotfiles 2>&1 > /dev/null
    print "ok"
  else
    print "dotfiles directory already exists."
  fi

  print -n "Fetching dbasik..."
  if [ ! -d ~/code/python/dbasik ]; then
    git clone git@github.com:yulqen/dbasik.git ~/code/python/dbasik  2>&1 > /dev/null
    print "ok"
  else
    print "dbasik directory already exists."
  fi

  print -n "Fetching datamaps..."
  if [ ! -d ~/code/python/datamaps ]; then
    git clone git@github.com:yulqen/datamaps.git ~/code/python/datamaps 2>&1 > /dev/null
    print "ok"
  else
    print "datamaps directory already exists."
  fi

  print -n "Fetching bcompiler-engine..."
  if [ ! -d ~/code/python/bcompiler-engine ]; then
    git clone git@github.com:yulqen/bcompiler-engine.git ~/code/python/bcompiler-engine 2>&1 > /dev/null
    print "ok"
  else
    print "bcompiler-engine directory already exists."
  fi

  print -n "Creating code-related symlinks..."
  ln -sf openbsddotfiles/pdbrc .pdbrc
  ln -sf openbsddotfiles/pdbrc.py .pdbrc.py
  ln -sf openbsddotfiles/flake8 /home/lemon/.config/.flake8
  ln -sf $(which fzf) ~/.fzf
  print "ok"
fi


print -n "Creating regular symlinks..."
cd ~
ln -sf openbsddotfiles/kshrc_vm_provision .kshrc
ln -sf openbsddotfiles/ksh_aliases .ksh_aliases
ln -sf openbsddotfiles/profile_vm_provisioning .profile
ln -sf openbsddotfiles/tmux.conf .tmux.conf
ln -shf openbsddotfiles/vim ~/.vim
ln -sf openbsddotfiles/gitconfig .gitconfig
ln -sf openbsddotfiles/gitignore_global .gitignore_global
print "ok"


