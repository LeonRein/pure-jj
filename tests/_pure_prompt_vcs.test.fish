source (status dirname)/fixtures/constants.fish
source (status dirname)/../functions/_pure_prompt_vcs.fish
source (status dirname)/../functions/_pure_prompt_git.fish
source (status dirname)/../functions/_pure_prompt_git_branch.fish
source (status dirname)/../functions/_pure_parse_git_branch.fish
source (status dirname)/../functions/_pure_prompt_git_stash.fish
source (status dirname)/../functions/_pure_prompt_jj.fish
source (status dirname)/../functions/_pure_prompt_jj_change_id.fish
source (status dirname)/../functions/_pure_prompt_jj_status.fish
source (status dirname)/../functions/_pure_prompt_jj_bookmark.fish
source (status dirname)/../functions/_pure_prompt_jj_dirty.fish
source (status dirname)/../functions/_pure_string_width.fish

@echo (_print_filename (status filename))

function before_each
    mkdir -p /tmp/test_pure_prompt_vcs/bin
    set -gx OLD_PATH $PATH
    set -gx PATH /tmp/test_pure_prompt_vcs/bin $PATH

    printf '%s\n' \
        '#!/bin/sh' \
        'if [ "$1" = "root" ]; then' \
        '    echo "/tmp/test_pure_prompt_vcs"' \
        '    exit 0' \
        'fi' \
        'case "$*" in' \
        '    *bookmarks*)' \
        '        echo "main"' \
        '        ;;' \
        '    *change_id*)' \
        '        echo "abcd"' \
        '        ;;' \
        '    *empty*)' \
        '        echo ""' \
        '        ;;' \
        '    *)' \
        '        echo "abcd"' \
        '        ;;' \
        'esac' > /tmp/test_pure_prompt_vcs/bin/jj

    chmod +x /tmp/test_pure_prompt_vcs/bin/jj

    _purge_configs
    _disable_colors
end

function after_each
    set -gx PATH $OLD_PATH
    rm -rf /tmp/test_pure_prompt_vcs
end


before_each
@test "_pure_prompt_vcs: prefers jj over git when both are available" (
    set --universal pure_enable_git true
    set --universal pure_enable_jj true

    mkdir -p /tmp/test_pure_prompt_vcs/repo
    cd /tmp/test_pure_prompt_vcs/repo
    git init --quiet

    _pure_prompt_vcs | strip_ansi
) = 'abcd (main)'
after_each

before_each
@test "_pure_prompt_vcs: displays jj status when in non-git directory" (
    set --universal pure_enable_git true
    set --universal pure_enable_jj true

    _pure_prompt_vcs | strip_ansi
) = 'abcd (main)'
after_each

before_each
@test "_pure_prompt_vcs: falls back to git when jj is disabled" (
    set --universal pure_enable_git true
    set --universal pure_enable_jj false

    mkdir -p /tmp/test_pure_prompt_vcs/repo
    cd /tmp/test_pure_prompt_vcs/repo
    git init --quiet

    function _pure_prompt_git_dirty; echo $EMPTY; end
    function _pure_prompt_git_pending_commits; echo $EMPTY; end

    _pure_prompt_vcs
) = 'master'
after_each

before_each
@test "_pure_prompt_vcs: returns empty when both are disabled" (
    set --universal pure_enable_git false
    set --universal pure_enable_jj false

    _pure_prompt_vcs
) $status -eq $SUCCESS
after_each
