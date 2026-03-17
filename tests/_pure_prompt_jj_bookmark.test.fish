source (status dirname)/fixtures/constants.fish
source (status dirname)/mocks/spectra.fish
source (status dirname)/../functions/_pure_prompt_jj_bookmark.fish
@echo (_print_filename (status filename))


function before_each
    mkdir -p /tmp/test_pure_prompt_jj_bookmark/bin
    set -gx OLD_PATH $PATH
    set -gx PATH /tmp/test_pure_prompt_jj_bookmark/bin $PATH

    _purge_configs
    _disable_colors
end

function after_each
    set -gx PATH $OLD_PATH
    rm -rf /tmp/test_pure_prompt_jj_bookmark
end


before_each
@test "_pure_prompt_jj_bookmark: shows bookmark name" (
    printf '%s\n' \
        '#!/bin/sh' \
        'case "$*" in' \
        '    *local_bookmarks*\\n*)' \
        '        echo "main"' \
        '        ;;' \
        '    *tracking_ahead_count*)' \
        '        printf "0\n0\n"' \
        '        ;;' \
        'esac' > /tmp/test_pure_prompt_jj_bookmark/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_bookmark/bin/jj

    set --universal pure_show_numbered_jj_indicator false

    _pure_prompt_jj_bookmark
) = '(main)'(set_color normal)
after_each

before_each
@test "_pure_prompt_jj_bookmark: no bookmark returns empty" (
    printf '%s\n' '#!/bin/sh' 'echo ""' > /tmp/test_pure_prompt_jj_bookmark/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_bookmark/bin/jj

    _pure_prompt_jj_bookmark
) = ''
after_each

before_each
@test "_pure_prompt_jj_bookmark: shows multiple bookmarks" (
    printf '%s\n' \
        '#!/bin/sh' \
        'case "$*" in' \
        '    *local_bookmarks*\\n*)' \
        '        printf "main\ndevelop\n"' \
        '        ;;' \
        '    *tracking_ahead_count*)' \
        '        printf "0\n0\n"' \
        '        ;;' \
        'esac' > /tmp/test_pure_prompt_jj_bookmark/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_bookmark/bin/jj

    set --universal pure_show_numbered_jj_indicator false

    _pure_prompt_jj_bookmark
) = '(main, develop)'(set_color normal)
after_each

before_each
@test "_pure_prompt_jj_bookmark: bookmark is colorized" (
    printf '%s\n' \
        '#!/bin/sh' \
        'case "$*" in' \
        '    *local_bookmarks*\\n*)' \
        '        echo "main"' \
        '        ;;' \
        '    *tracking_ahead_count*)' \
        '        printf "0\n0\n"' \
        '        ;;' \
        'esac' > /tmp/test_pure_prompt_jj_bookmark/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_bookmark/bin/jj

    _pure_unmock _pure_set_color # enable colors
    set --universal pure_color_jj_bookmark grey
    set --universal pure_show_numbered_jj_indicator false

    _pure_prompt_jj_bookmark
) = (set_color grey)'(main)'(set_color normal)
after_each

before_each
@test "_pure_prompt_jj_bookmark: shows ahead symbol when tracking ahead" (
    printf '%s\n' \
        '#!/bin/sh' \
        'case "$*" in' \
        '    *local_bookmarks*\\n*)' \
        '        echo "main"' \
        '        ;;' \
        '    *tracking_ahead_count*)' \
        '        printf "2\n0\n"' \
        '        ;;' \
        'esac' > /tmp/test_pure_prompt_jj_bookmark/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_bookmark/bin/jj

    set --universal pure_symbol_jj_ahead '^'
    set --universal pure_show_numbered_jj_indicator false

    _pure_prompt_jj_bookmark
) = '(main)'(set_color normal)' ^'
after_each

before_each
@test "_pure_prompt_jj_bookmark: shows numbered ahead count when enabled" (
    printf '%s\n' \
        '#!/bin/sh' \
        'case "$*" in' \
        '    *local_bookmarks*\\n*)' \
        '        echo "main"' \
        '        ;;' \
        '    *tracking_ahead_count*)' \
        '        printf "3\n0\n"' \
        '        ;;' \
        'esac' > /tmp/test_pure_prompt_jj_bookmark/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_bookmark/bin/jj

    set --universal pure_symbol_jj_ahead '^'
    set --universal pure_show_numbered_jj_indicator true

    _pure_prompt_jj_bookmark
) = '(main)'(set_color normal)' ^3'
after_each

before_each
@test "_pure_prompt_jj_bookmark: shows behind symbol when remote has new changes" (
    printf '%s\n' \
        '#!/bin/sh' \
        'case "$*" in' \
        '    *local_bookmarks*\\n*)' \
        '        echo "main"' \
        '        ;;' \
        '    *tracking_ahead_count*)' \
        '        printf "0\n2\n"' \
        '        ;;' \
        'esac' > /tmp/test_pure_prompt_jj_bookmark/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_bookmark/bin/jj

    set --universal pure_symbol_jj_behind 'v'
    set --universal pure_show_numbered_jj_indicator false

    _pure_prompt_jj_bookmark
) = '(main)'(set_color normal)' v'
after_each

before_each
@test "_pure_prompt_jj_bookmark: shows numbered behind count when enabled" (
    printf '%s\n' \
        '#!/bin/sh' \
        'case "$*" in' \
        '    *local_bookmarks*\\n*)' \
        '        echo "main"' \
        '        ;;' \
        '    *tracking_ahead_count*)' \
        '        printf "0\n2\n"' \
        '        ;;' \
        'esac' > /tmp/test_pure_prompt_jj_bookmark/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_bookmark/bin/jj

    set --universal pure_symbol_jj_behind 'v'
    set --universal pure_show_numbered_jj_indicator true

    _pure_prompt_jj_bookmark
) = '(main)'(set_color normal)' v2'
after_each

before_each
@test "_pure_prompt_jj_bookmark: shows both ahead and behind" (
    printf '%s\n' \
        '#!/bin/sh' \
        'case "$*" in' \
        '    *local_bookmarks*\\n*)' \
        '        echo "main"' \
        '        ;;' \
        '    *tracking_ahead_count*)' \
        '        printf "1\n2\n"' \
        '        ;;' \
        'esac' > /tmp/test_pure_prompt_jj_bookmark/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_bookmark/bin/jj

    set --universal pure_symbol_jj_ahead '^'
    set --universal pure_symbol_jj_behind 'v'
    set --universal pure_show_numbered_jj_indicator false

    _pure_prompt_jj_bookmark
) = '(main)'(set_color normal)' ^v'
after_each

before_each
@test "_pure_prompt_jj_bookmark: no remote tracking returns only bookmark" (
    printf '%s\n' \
        '#!/bin/sh' \
        'case "$*" in' \
        '    *local_bookmarks*\\n*)' \
        '        echo "main"' \
        '        ;;' \
        '    *tracking_ahead_count*)' \
        '        ;;' \
        'esac' > /tmp/test_pure_prompt_jj_bookmark/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_bookmark/bin/jj

    set --universal pure_symbol_jj_ahead '^'
    set --universal pure_symbol_jj_behind 'v'
    set --universal pure_show_numbered_jj_indicator false

    _pure_prompt_jj_bookmark
) = '(main)'(set_color normal)
after_each

before_each
@test "_pure_prompt_jj_bookmark: ahead/behind symbol is colorized" (
    printf '%s\n' \
        '#!/bin/sh' \
        'case "$*" in' \
        '    *local_bookmarks*\\n*)' \
        '        echo "main"' \
        '        ;;' \
        '    *tracking_ahead_count*)' \
        '        printf "1\n0\n"' \
        '        ;;' \
        'esac' > /tmp/test_pure_prompt_jj_bookmark/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_bookmark/bin/jj

    _pure_unmock _pure_set_color # enable colors
    set --universal pure_symbol_jj_ahead '^'
    set --universal pure_color_jj_ahead cyan
    set --universal pure_color_jj_bookmark grey
    set --universal pure_show_numbered_jj_indicator false

    _pure_prompt_jj_bookmark
) = (set_color grey)'(main)'(set_color normal)' '(set_color cyan)'^'
after_each

before_each
@test "_pure_prompt_jj_bookmark: falls back to ancestor bookmarks when descendant list is empty" (
    printf '%s\n' \
        '#!/bin/sh' \
        'case "$*" in' \
        '    *"-r @:: & bookmarks()"*)' \
        '        echo ""' \
        '        ;;' \
        '    *"-r heads(::@ & bookmarks())"*)' \
        '        echo "main"' \
        '        ;;' \
        '    *tracking_ahead_count*)' \
        '        printf "0\n0\n"' \
        '        ;;' \
        'esac' > /tmp/test_pure_prompt_jj_bookmark/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_bookmark/bin/jj

    set --universal pure_show_numbered_jj_indicator false

    _pure_prompt_jj_bookmark
) = '(main)'(set_color normal)
after_each

before_each
@test "_pure_prompt_jj_bookmark: shows only first three bookmarks then ellipsis" (
    printf '%s\n' \
        '#!/bin/sh' \
        'case "$*" in' \
        '    *"-r @:: & bookmarks()"*)' \
        '        printf "main\ndevelop\nrelease\nfeature\n"' \
        '        ;;' \
        '    *tracking_ahead_count*)' \
        '        printf "0\n0\n"' \
        '        ;;' \
        'esac' > /tmp/test_pure_prompt_jj_bookmark/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_bookmark/bin/jj

    set --universal pure_show_numbered_jj_indicator false

    _pure_prompt_jj_bookmark
) = '(main, develop, release, ...)'(set_color normal)
after_each

before_each
@test "_pure_prompt_jj_bookmark: sums ahead and behind over first three bookmarks" (
    printf '%s\n' \
        '#!/bin/sh' \
        'case "$*" in' \
        '    *"-r @:: & bookmarks()"*)' \
        '        printf "main\ndevelop\nrelease\nfeature\n"' \
        '        ;;' \
        '    *"remote_bookmarks(main)"*tracking_ahead_count*)' \
        '        printf "1\n2\n"' \
        '        ;;' \
        '    *"remote_bookmarks(develop)"*tracking_ahead_count*)' \
        '        printf "3\n4\n"' \
        '        ;;' \
        '    *"remote_bookmarks(release)"*tracking_ahead_count*)' \
        '        printf "5\n6\n"' \
        '        ;;' \
        '    *"remote_bookmarks(feature)"*tracking_ahead_count*)' \
        '        printf "100\n100\n"' \
        '        ;;' \
        'esac' > /tmp/test_pure_prompt_jj_bookmark/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_bookmark/bin/jj

    set --universal pure_symbol_jj_ahead '^'
    set --universal pure_symbol_jj_behind 'v'
    set --universal pure_show_numbered_jj_indicator true

    _pure_prompt_jj_bookmark
) = '(main, develop, release, ...)'(set_color normal)' ^9v12'
after_each
