node_version() {
    local dir="$PWD"

    if [[ -f "$dir/.nvmrc" ]] && [[ "$dir" != "$HOME" ]]; then
        nvm use &> /dev/null
    fi

    while [[ "$dir" != "/" ]]; do
        if [[ -f "$dir/package.json" ]]; then
            local node_version
            node_version=$(node -v 2> /dev/null)

            if [[ $? -eq 0 ]]; then
                echo -en "($node_version) "
            fi
        fi
        dir=$(dirname "$dir")
    done
}