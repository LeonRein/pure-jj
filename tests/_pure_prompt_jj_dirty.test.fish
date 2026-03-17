source (status dirname)/fixtures/constants.fish
source (status dirname)/mocks/spectra.fish
source (status dirname)/../functions/_pure_prompt_jj_dirty.fish
@echo (_print_filename (status filename))


function before_each
    mkdir -p /tmp/test_pure_prompt_jj_dirty/bin
    set -gx OLD_PATH $PATH
    set -gx PATH /tmp/test_pure_prompt_jj_dirty/bin $PATH

    _purge_configs
    _disable_colors
end

function after_each
    set -gx PATH $OLD_PATH
    rm -rf /tmp/test_pure_prompt_jj_dirty
end


before_each
@test "_pure_prompt_jj_dirty: empty change is not marked as dirty" (
    printf '%s\n' '#!/bin/sh' 'echo ""' > /tmp/test_pure_prompt_jj_dirty/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_dirty/bin/jj

    set --universal pure_symbol_jj_dirty '*'

    _pure_prompt_jj_dirty
) = ''
after_each

before_each
@test "_pure_prompt_jj_dirty: non-empty change is marked as dirty" (
    printf '%s\n' '#!/bin/sh' 'echo "dirty"' > /tmp/test_pure_prompt_jj_dirty/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_dirty/bin/jj

    set --universal pure_symbol_jj_dirty '*'

    _pure_prompt_jj_dirty
) = '*'
after_each

before_each
@test "_pure_prompt_jj_dirty: symbol is colorized" (
    printf '%s\n' '#!/bin/sh' 'echo "dirty"' > /tmp/test_pure_prompt_jj_dirty/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_dirty/bin/jj

    _pure_unmock _pure_set_color # enable colors
    set --universal pure_symbol_jj_dirty '*'
    set --universal pure_color_jj_dirty brblack

    _pure_prompt_jj_dirty
) = (set_color brblack)'*'
after_each
