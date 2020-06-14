#!/bin/bash

packages=(
    "autoconf"
    "automake"
    "bison"
    "flex"
    "gperf"
    "libtool"
    "m4"
    "perl"
    "wget"
    "git"
    "vim"
)

if [ -z "$(command -v gtags)" ] ||
    [ ! -f ~/.vim/plugin/gtags.vim ] ||
    [ ! -f ~/.vim/plugin/gtags-cscope.vim ]; then
    for package in "${packages[@]}"; do
        if [ -z "$(command -v $package)" ]; then
            brew install $package
        fi
    done

    GTAGS_VERSION="global-6.6.3"
    GTAGS_ARCHIVE="$GTAGS_VERSION.tar.gz"
    wget http://tamacom.com/global/$GTAGS_ARCHIVE
    tar zxf $GTAGS_ARCHIVE
    if [ -d $GTAGS_VERSION ]; then
        (
        cd $GTAGS_VERSION
        sh reconf.sh
        ./configure
        make && make install
        mkdir -p ~/.vim/plugin
        cp -v /usr/local/share/gtags/gtags.vim ~/.vim/plugin/gtags.vim
        cp -v /usr/local/share/gtags/gtags-cscope.vim ~/.vim/plugin/gtags-cscope.vim
        )
    fi
    rm -rf global*
fi

if [ -d vimrc ]; then
    echo "let \$vimconfig= "\"$PWD\" > vimrc/.vimrc
    # profile
    if [ -f vimrc/profile.vim ]; then
        echo "source \$vimconfig/vimrc/profile.vim" >> vimrc/.vimrc
    fi
    # keymap
    if [ -f vimrc/keymap.vim ]; then
        echo "source \$vimconfig/vimrc/keymap.vim" >> vimrc/.vimrc
    fi
    # function
    if [ -f vimrc/function.vim ]; then
        echo "source \$vimconfig/vimrc/function.vim" >> vimrc/.vimrc
    fi
    # plugin_config
    if [ -f vimrc/plugin_config.vim ]; then
        echo "source \$vimconfig/vimrc/plugin_config.vim" >> vimrc/.vimrc
    fi
    # clipboard
    echo "set clipboard=unnamed" >> vimrc/.vimrc
    # why not work '.' after 'ln', so '$PWD' is used
    ln -svf $PWD/vimrc/.vimrc ~/.vimrc
fi

mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall