#!/usr/bin/env bash

python_virtualenv() {
    if [[ $VIRTUAL_ENV ]]; then
        project_name=$(basename $(dirname $VIRTUAL_ENV))
        python_version=$(python --version)
        short="${python_version##* }"       
        echo "($project_name/py$short) "
    fi
}

