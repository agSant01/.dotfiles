#!/usr/bin/env bash

VENV_FOLDER_NAMES=(venv virtualenv)

activate_pyvenv() {
    for VENV_NAME in ${VENV_FOLDER_NAMES}; do
        if [[ -d $VENV_NAME ]]; then
            source $PWD/$VENV_NAME/bin/activate
        fi
    done
}

python_virtualenv() {

    if [[ $VIRTUAL_ENV ]]; then
        project_name=$(basename $(dirname $VIRTUAL_ENV))
        python_version=$(python --version)
        short="${python_version##* }"
        echo "($project_name/py$short) "
    fi
}

