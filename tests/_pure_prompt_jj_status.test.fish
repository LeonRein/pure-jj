source (status dirname)/fixtures/constants.fish
source (status dirname)/mocks/spectra.fish
source (status dirname)/../functions/_pure_prompt_jj_status.fish
@echo (_print_filename (status filename))


function before_each
    mkdir -p /tmp/test_pure_prompt_jj_status/bin
    set -gx OLD_PATH $PATH
    set -gx PATH /tmp/test_pure_prompt_jj_status/bin $PATH

    _purge_configs
    _disable_colors
end

function after_each
    set -gx PATH $OLD_PATH
    rm -rf /tmp/test_pure_prompt_jj_status
end


before_each
@test "_pure_prompt_jj_status: no flags returns empty" (
    printf '%s\n' '#!/bin/sh' 'echo ""' > /tmp/test_pure_prompt_jj_status/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_status/bin/jj

    _pure_prompt_jj_status
) = ''
after_each

before_each
@test "_pure_prompt_jj_status: shows immutable flag" (
    printf '%s\n' '#!/bin/sh' 'echo "immutable"' > /tmp/test_pure_prompt_jj_status/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_status/bin/jj

    set --universal pure_symbol_jj_immutable "⊙"

    _pure_prompt_jj_status
) = '⊙ '
after_each

before_each
@test "_pure_prompt_jj_status: shows hidden flag" (
    printf '%s\n' '#!/bin/sh' 'echo "hidden"' > /tmp/test_pure_prompt_jj_status/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_status/bin/jj

    set --universal pure_symbol_jj_hidden "⊘"

    _pure_prompt_jj_status
) = '⊘ '
after_each

before_each
@test "_pure_prompt_jj_status: shows empty flag" (
    printf '%s\n' '#!/bin/sh' 'echo "empty"' > /tmp/test_pure_prompt_jj_status/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_status/bin/jj

    set --universal pure_symbol_jj_empty "∅"

    _pure_prompt_jj_status
) = '∅ '
after_each

before_each
@test "_pure_prompt_jj_status: shows conflict flag" (
    printf '%s\n' '#!/bin/sh' 'echo "conflict"' > /tmp/test_pure_prompt_jj_status/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_status/bin/jj

    set --universal pure_symbol_jj_conflict "✖"

    _pure_prompt_jj_status
) = '✖ '
after_each

before_each
@test "_pure_prompt_jj_status: shows multiple flags" (
    printf '%s\n' '#!/bin/sh' 'echo "immutable empty"' > /tmp/test_pure_prompt_jj_status/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_status/bin/jj

    set --universal pure_symbol_jj_immutable "⊙"
    set --universal pure_symbol_jj_empty "∅"

    _pure_prompt_jj_status
) = '⊙ ∅ '
after_each

before_each
@test "_pure_prompt_jj_status: symbol is colorized" (
    printf '%s\n' '#!/bin/sh' 'echo "immutable"' > /tmp/test_pure_prompt_jj_status/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_status/bin/jj

    _pure_unmock _pure_set_color # enable colors
    set --universal pure_symbol_jj_immutable "⊙"
    set --universal pure_color_jj_status brblack

    _pure_prompt_jj_status
) = (set_color brblack)'⊙ '
after_each
