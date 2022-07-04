#!/bin/ksh

# download ISO from https://cdn.openbsd.org/pub/OpenBSD/$(uname -r)/amd64/install71.iso

INC_CODE=0


usage()
{
  print "Usage: $0 [-c]"
  print -R '-c - require repositories to be downloaded from github'
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

dbasik_src=~/code/python/dbasik
datamaps_src=~/code/python/datamaps
bcompiler_src=~/code/python/bcompiler-engine
ded_src=~/code/python/ded

command -v vim > /dev/null 2>&1
if [ "$?" != 0 ]; then
  doas pkg_add vim
fi

create_venvs() {
    cd $1
    print "Creating the virtualenv at $1/.venv. This might take a couple of minutes..."
    print -n "Creating virtualenv..."
    python3 -m venv .venv
    . ./.venv/bin/activate
    print "ok"
    if [ -a requirements.txt ]; then
      print -n "Installing from requirements.txt..."
      pip install -r requirements.txt > /dev/null 2>&1
      pip install -U pip > /dev/null 2>&1
      print "ok"
    fi
    if [ -a requirements_dev.txt ]; then
      print -n "Installing from requirements_dev.txt..."
      pip install -r requirements_dev.txt > /dev/null 2>&1
      pip install -U pip > /dev/null 2>&1
      print "ok"
    fi
    deactivate && cd ~
    print "virtualenv created"
}

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
    git clone git@github.com:yulqen/openbsddotfiles.git ~/openbsddotfiles > /dev/null 2>&1
    print "ok"
  else
    print "dotfiles directory already exists."
  fi

  print -n "Fetching ded..."
  if [ ! -d $ded_src ]; then
    git clone git@gitlab.com:yulqen/ded.git $ded_src > /dev/null 2>&1
    print "ok"
    create_venvs $ded_src
  else
    print "dbasik directory already exists."
  fi

  print -n "Fetching dbasik..."
  if [ ! -d $dbasik_src ]; then
    git clone git@github.com:yulqen/dbasik.git $dbasik_src > /dev/null 2>&1
    print "ok"
    create_venvs $dbasik_src
  else
    print "dbasik directory already exists."
  fi

  print -n "Fetching datamaps..."
  if [ ! -d $datamaps_src ]; then
    git clone git@github.com:yulqen/datamaps.git $datamaps_src > /dev/null 2>&1
    print "ok"
    create_venvs $datamaps_src
  else
    print "datamaps directory already exists."
  fi

  print -n "Fetching bcompiler-engine..."
  if [ ! -d $bcompiler_src ]; then
    git clone git@github.com:yulqen/bcompiler-engine.git $bcompiler_src > /dev/null 2>&1
    print "ok"
    create_venvs $bcompiler_src
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


