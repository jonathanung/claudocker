clod-join(){
    local shell="/bin/bash"
    local container=""

    for arg in "$@"; do
        case "$arg" in
            -t|--tmux) shell="tmux new-session -s workspace" ;;
            -z|--zsh) shell="/bin/zsh" ;;
            *) container="$arg" ;;
        esac
    done

    container="${container:-claude-workspace}"

    docker exec -it "$container" $shell
}

clod-join "$@"