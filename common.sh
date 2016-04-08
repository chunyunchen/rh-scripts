#!/bin/bash

red_prefix="\033[31;49;1m"
green_prefix="\033[32;49;1m"
blue_prefix="\033[34;49;1m"
color_suffix="\033[39;49;0m"

function set_bash {
    local bash_name="$1"
    local bash_cli="$2"
    local bash_file=~/.bashrc
    aliasos="$(grep "^alias $bash_name=" $bash_file; echo -n)"
    [ -z "$aliasos" ] && echo "alias $bash_name=\"$bash_cli\"" >> $bash_file
    [ "$aliasos" ] && sed -i "/$bash_name/c alias $bash_name=\"$bash_cli\"" $bash_file
    echo -e "Run \033[31;49;1msource $bash_file\033[39;49;0m , then can login master host via command: \033[32;49;1m$bash_name\033[39;49;0m"
}

## https://github.com/openshift/openshift-ansible -b openshift-ansible-3.0.72-1
