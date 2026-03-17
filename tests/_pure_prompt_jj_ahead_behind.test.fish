source (status dirname)/fixtures/constants.fish
source (status dirname)/mocks/spectra.fish
source (status dirname)/../functions/_pure_prompt_jj_ahead_behind.fish
@echo (_print_filename (status filename))


function before_each
    mkdir -p /tmp/test_pure_prompt_jj_ahead_behind/bin
    set -gx OLD_PATH $PATH
    set -gx PATH /tmp/test_pure_prompt_jj_ahead_behind/bin $PATH

    _purge_configs
    _disable_colors
end

function after_each
    set -gx PATH $OLD_PATH
    rm -rf /tmp/test_pure_prompt_jj_ahead_behind
end


before_each
@test "_pure_prompt_jj_ahead_behind: no bookmark returns empty" (
    printf '%s\n' '#!/bin/sh' 'echo ""' > /tmp/test_pure_prompt_jj_ahead_behind/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_ahead_behind/bin/jj

    _pure_prompt_jj_ahead_behind
) = ''
after_each

before_each
@test "_pure_prompt_jj_ahead_behind: shows ahead symbol when changes ahead of bookmark" (
    printf '%s\n' \
        '#!/bin/sh' \
        'case "$*" in' \
        '    *bookmarks*\\n*)' \
        '        echo "main"' \
        '        ;;' \
        '    *"main..@"*)' \
        '        printf ".\n.\n"' \
        '        ;;' \
        '    *"@..main@origin"*)' \
        '        ;;' \
        'esac' > /tmp/test_pure_prompt_jj_ahead_behind/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_ahead_behind/bin/jj

    set --universal pure_symbol_jj_ahead '^'
    set --universal pure_show_numbered_jj_indicator false

    _pure_prompt_jj_ahead_behind
) = '^'
after_each

before_each
@test "_pure_prompt_jj_ahead_behind: shows numbered ahead count when enabled" (
    printf '%s\n' \
        '#!/bin/sh' \
        'case "$*" in' \
        '    *bookmarks*\\n*)' \
        '        echo "main"' \
        '        ;;' \
        '    *"main..@"*)' \
        '        printf ".\n.\n.\n"' \
        '        ;;' \
        '    *"@..main@origin"*)' \
        '        ;;' \
        'esac' > /tmp/test_pure_prompt_jj_ahead_behind/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_ahead_behind/bin/jj

    set --universal pure_symbol_jj_ahead '^'
    set --universal pure_show_numbered_jj_indicator true

    _pure_prompt_jj_ahead_behind
) = '^3'
after_each

before_each
@test "_pure_prompt_jj_ahead_behind: shows behind symbol when remote has new changes" (
    printf '%s\n' \
        '#!/bin/sh' \
        'case "$*" in' \
        '    *bookmarks*\\n*)' \
        '        echo "main"' \
        '        ;;' \
        '    *"main..@"*)' \
        '        ;;' \
        '    *"@..main@origin"*)' \
        '        printf ".\n.\n"' \
        '        ;;' \
        'esac' > /tmp/test_pure_prompt_jj_ahead_behind/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_ahead_behind/bin/jj

    set --universal pure_symbol_jj_behind 'v'
    set --universal pure_show_numbered_jj_indicator false

    _pure_prompt_jj_ahead_behind
) = v
after_each

before_each
@test "_pure_prompt_jj_ahead_behind: shows numbered behind count when enabled" (
    printf '%s\n' \
        '#!/bin/sh' \
        'case "$*" in' \
        '    *bookmarks*\\n*)' \
        '        echo "main"' \
        '        ;;' \
        '    *"main..@"*)' \
        '        ;;' \
        '    *"@..main@origin"*)' \
        '        printf ".\n.\n"' \
        '        ;;' \
        'esac' > /tmp/test_pure_prompt_jj_ahead_behind/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_ahead_behind/bin/jj

    set --universal pure_symbol_jj_behind 'v'
    set --universal pure_show_numbered_jj_indicator true

    _pure_prompt_jj_ahead_behind
) = 'v2'
after_each

before_each
@test "_pure_prompt_jj_ahead_behind: shows both ahead and behind" (
    printf '%s\n' \
        '#!/bin/sh' \
        'case "$*" in' \
        '    *bookmarks*\\n*)' \
        '        echo "main"' \
        '        ;;' \
        '    *"main..@"*)' \
        '        printf ".\n"' \
        '        ;;' \
        '    *"@..main@origin"*)' \
        '        printf ".\n.\n"' \
        '        ;;' \
        'esac' > /tmp/test_pure_prompt_jj_ahead_behind/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_ahead_behind/bin/jj

    set --universal pure_symbol_jj_ahead '^'
    set --universal pure_symbol_jj_behind 'v'
    set --universal pure_show_numbered_jj_indicator false

    _pure_prompt_jj_ahead_behind
) = '^v'
after_each

before_each
@test "_pure_prompt_jj_ahead_behind: no remote tracking returns only ahead" (
    printf '%s\n' \
        '#!/bin/sh' \
        'case "$*" in' \
        '    *bookmarks*\\n*)' \
        '        echo "main"' \
        '        ;;' \
        '    *"main..@"*)' \
        '        printf ".\n"' \
        '        ;;' \
        '    *"@..main@origin"*)' \
        '        exit 1' \
        '        ;;' \
        'esac' > /tmp/test_pure_prompt_jj_ahead_behind/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_ahead_behind/bin/jj

    set --universal pure_symbol_jj_ahead '^'
    set --universal pure_symbol_jj_behind 'v'
    set --universal pure_show_numbered_jj_indicator false

    _pure_prompt_jj_ahead_behind
) = '^'
after_each

before_each
@test "_pure_prompt_jj_ahead_behind: symbol is colorized" (
    printf '%s\n' \
        '#!/bin/sh' \
        'case "$*" in' \
        '    *bookmarks*\\n*)' \
        '        echo "main"' \
        '        ;;' \
        '    *"main..@"*)' \
        '        printf ".\n"' \
        '        ;;' \
        '    *"@..main@origin"*)' \
        '        ;;' \
        'esac' > /tmp/test_pure_prompt_jj_ahead_behind/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_ahead_behind/bin/jj

    _pure_unmock _pure_set_color # enable colors
    set --universal pure_symbol_jj_ahead '^'
    set --universal pure_color_jj_ahead cyan
    set --universal pure_show_numbered_jj_indicator false

    _pure_prompt_jj_ahead_behind
) = (set_color cyan)'^'
after_each
