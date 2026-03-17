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
    printf '%s\n' '#!/bin/sh' 'echo "main"' > /tmp/test_pure_prompt_jj_bookmark/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_bookmark/bin/jj

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
    printf '%s\n' '#!/bin/sh' 'echo "main, develop"' > /tmp/test_pure_prompt_jj_bookmark/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_bookmark/bin/jj

    _pure_prompt_jj_bookmark
) = '(main, develop)'(set_color normal)
after_each

before_each
@test "_pure_prompt_jj_bookmark: bookmark is colorized" (
    printf '%s\n' '#!/bin/sh' 'echo "main"' > /tmp/test_pure_prompt_jj_bookmark/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_bookmark/bin/jj

    _pure_unmock _pure_set_color # enable colors
    set --universal pure_color_jj_bookmark grey

    _pure_prompt_jj_bookmark
) = (set_color grey)'(main)'(set_color normal)
after_each
