export GIT_REPO_DIR="/repo"

goto_git_repo_dir() {
    [ ! -d "$GIT_REPO_DIR" ] && {
        echo "Failed: repo dir $GIT_REPO_DIR DOES NOT exists."
        return 1
    }
    cd "$GIT_REPO_DIR"
}

standard_repo_name() {
    local repo="$1"
    [ -z "$repo" ] && return 1
    [ "${repo##*.}" != "git" ] && {
        echo "Changed: $repo => $repo.git" 1>&2
        echo "$repo.git"
    } || echo "$repo"
}

check_repo_name() {
    local repo="$1"
    local fail_if_exists="$2"

    [ -z "$repo" ] && {
        echo "Failed: missing repo name."
        return 1
    }

    # 必须以.git结尾
    [ "${repo##*.}" != "git" ] && {
        echo "Failed: repo name MUST end with .git"
        return 1
    }

    # 已存在则失败
    [ -n "$fail_if_exists" ] && [ -d "$repo" ] && {
        echo "Failed: repo '$repo' already exists."
        return 1
    }

    return 0
}
