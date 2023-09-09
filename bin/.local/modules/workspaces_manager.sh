#!/usr/bin/env bash

DEFAULT_EDITOR="code"
BASE_DIR="$HOME/.bash_code_workspaces"

BULLET_TRIANGLE="\u27A4"
ERROR_X="\u274C"

FMT_FILE_PRINT="\e[3;36m"
FMT_END="\e[0m"

ansi()          { echo -e "\e[${1}m${*:2}\e[0m"; }
bold()          { ansi 1 "$@"; }
italic()        { ansi 3 "$@"; }
underline()     { ansi 4 "$@"; }

## create workspaces directory if it not exists
if [ ! -d ~/.bash_code_workspaces ]; then
    mkdir ~/.bash_code_workspaces
fi

function header() {
    printf "=> Welcome to the Bash Scripting Worskspace Manager.\n\n"
}

function showHelp() {
    header
    printf "Help Center:\n"
    printf " mkwspc   <workspace-name>  Create a new workspace in ~/.bash_code_workspaces\n"
    printf " lswspc                     List all the available workspaces.\n"
    printf " edwspc   <workspace-name>  Edit the workspace if it exists.\n"
    printf " inswspc  <workspace-name>  Inspect the contents of workspaces with unix 'less'\n"
    printf " xwspc    <workspace-name>  Execute the workspace as a script.\n"
    printf "                            It will execute the script with the privilegdes of the logged user. Use with caution.\n"
    printf "\n"
}

function validateInput() {
    if [[ ! -n $1 ]]; then
        printf "=> No workspace name provided...\n"
        printf "=> Showing Help Center instead...\n"
        showHelp
        return 1
    fi
    return 0
}

## Arguments
##  - filePath
##  - alias
function workspaceExists() {
    if [[ ! -e $1 ]]; then
        printf "=> Error:\n"
        printf "$ERROR_X Workspace \"$2\" does not exists.\n"

        printf "\n"

        printf "=> Tip:\n"
        printf " $BULLET_TRIANGLE Use $FMT_FILE_PRINT\"mkwspc <workspace-name>\"$FMT_END to create it.\n"
        return 1
    fi

    return 0
}

function lswspc() {
    header
    printf "Workspaces List:\n"
    for f in "$BASE_DIR"/*
    do
        # get filename
        local fileName=$(basename $f)

        # remove extension
        fileName=${fileName%.*}

        printf " $BULLET_TRIANGLE $fileName\n"
    done

    printf "\n\nAdditional Tips:\n"
    printf " $BULLET_TRIANGLE To inspect the contents of a workspace use $FMT_FILE_PRINT\"inswspc <workspace-name>\"$FMT_END\n"

    printf "\n"
}

function edwspc() {
    # validate passed name
    validateInput $1
    if [[ $? -eq 1 ]]; then
        return 1
    fi

    local filePath=$BASE_DIR/$1.sh

    workspaceExists $filePath $1
    if [[ $? -eq 1 ]]; then
        return 1
    fi


    $DEFAULT_EDITOR $filePath
}

function inswspc() {
    # validate passed name
    validateInput $1
    if [[ $? -eq 1 ]]; then
        return 1
    fi

    local filePath=$BASE_DIR/$1.sh

    # validate if wkspace exists
    workspaceExists $filePath $1
    if [[ $? -eq 1 ]]; then
        return 1
    fi

    less $filePath
}

function xwspc() {
    # validate passed name
    validateInput $1
    if [[ $? -eq 1 ]]; then
        return 1
    fi

    local filePath=$BASE_DIR/$1.sh

    # validate if wkspace exists
    workspaceExists $filePath $1
    if [[ $? -eq 1 ]]; then
        return 1
    fi

    bash $filePath
}


function mkwspc() {
    local projectDir="$(cd "$(dirname ".")"; pwd -P)"

    # validate passed name
    validateInput $1
    if [[ $? -eq 1 ]]; then
        return 1
    fi

    local alias_name=$1

    local fileName="$BASE_DIR/$alias_name.sh"

    if [[ -e $fileName ]]; then
        printf "=> Error:\n"
        printf "$ERROR_X File \"$fileName\" already exists.\n"

        printf "\n"

        printf "=> Tip:\n"
        printf " $BULLET_TRIANGLE Use $FMT_FILE_PRINT\"inswspc $alias_name\"$FMT_END to inspect its contents.\n"
        return 1
    fi

    touch $fileName
    printf "# Exit on first error\n" >> $fileName
    printf "set -e\n\n" >> $fileName
    printf "# Start\n" >> $fileName
    printf "echo \"==> Executing commands for workspace $alias_name...\"\n\n" >> $fileName
    printf "# Proyect directory\n" >> $fileName
    printf "BASE_DIR=$projectDir\n" >> $fileName
    printf "cd \$BASE_DIR\n\n" >> $fileName
    printf "# Write commands here\n\n\n\n" >> $fileName
    printf "# End\n" >> $fileName
    printf "echo \"==> Success executing commands for workspace $alias_name...\"\n" >> $fileName
    printf "Saved in: $fileName\n"

    $DEFAULT_EDITOR $fileName
}

function workspace-manager() {
    showHelp
}