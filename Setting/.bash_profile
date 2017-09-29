# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# User specific environment and startup programs

if [ -d $HOME/.local/bin ] ; then
    PATH=$PATH:$HOME/.local/bin
fi

if [ -d $HOME/bin ] ; then
    PATH=$PATH:$HOME/bin
fi

export PATH
#Load modules

export R_LIBS="/projects/$USER/R/library"
export PROJECTS=/projects/$USER

# Remove this if you don't want to display README at login
if [ -f ~/README.mdwn ]; then
    cat ~/README.mdwn
fi

cd $PROJECTS

ml gcc
ml R
ml slurm/summit