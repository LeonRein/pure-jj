source (status dirname)/fixtures/constants.fish
source (status dirname)/mocks/spectra.fish
source (status dirname)/../functions/_pure_prompt_jj_change_id.fish
@echo (_print_filename (status filename))


function before_each
    mkdir -p /tmp/test_pure_prompt_jj_change_id/bin
    set -gx OLD_PATH $PATH
    set -gx PATH /tmp/test_pure_prompt_jj_change_id/bin $PATH

    _purge_configs
    _disable_colors
end

function after_each
    set -gx PATH $OLD_PATH
    rm -rf /tmp/test_pure_prompt_jj_change_id
end


before_each
@test "_pure_prompt_jj_change_id: shows change ID" (
    printf '%s\n' '#!/bin/sh' 'echo "abcd"' > /tmp/test_pure_prompt_jj_change_id/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_change_id/bin/jj

    _pure_prompt_jj_change_id
) = abcd
after_each

before_each
@test "_pure_prompt_jj_change_id: preserves jj native coloring" (
    printf '%s\n' '#!/bin/sh' 'printf "\033[1;35mab\033[0m\033[35mcd\033[0m"' > /tmp/test_pure_prompt_jj_change_id/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_change_id/bin/jj

    _pure_prompt_jj_change_id | strip_ansi
) = abcd
after_each

before_each
@test "_pure_prompt_jj_change_id: returns empty when jj fails" (
    printf '%s\n' '#!/bin/sh' 'exit 1' > /tmp/test_pure_prompt_jj_change_id/bin/jj
    chmod +x /tmp/test_pure_prompt_jj_change_id/bin/jj

    _pure_prompt_jj_change_id
) = ''
after_each
