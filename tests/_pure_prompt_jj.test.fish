source (status dirname)/fixtures/constants.fish
source (status dirname)/../functions/_pure_prompt_jj.fish

@echo (_print_filename (status filename))

function before_all
    _purge_configs
    _disable_colors

    mkdir -p /tmp/test_pure_prompt_jj/bin
    set -gx OLD_PATH $PATH
    set -gx PATH /tmp/test_pure_prompt_jj/bin $PATH

    # Mock jj command for testing
    printf '%s\n' '#!/usr/bin/env fish' 'set -l template ""' 'for i in (seq (count $argv))' '    if test $argv[$i] = "-T"' '        set template $argv[(math $i + 1)]' '        break' '    end' 'end' 'if string match --quiet --regex "bookmarks" "$template"' '    echo main' 'else' '    echo "🔒 abcd"' 'end' > /tmp/test_pure_prompt_jj/bin/jj

    chmod +x /tmp/test_pure_prompt_jj/bin/jj
end
before_all

function after_all
    set -gx PATH $OLD_PATH
    rm -rf /tmp/test_pure_prompt_jj
end

@test "_pure_prompt_jj: displays jj status when jj is available" (
    set --universal pure_enable_git true

    _pure_prompt_jj | strip_ansi
) = '🔒 abcd (main)'

@test "_pure_prompt_jj: fails when jj is not available" (
    set -gx PATH /usr/bin $PATH  # remove mock jj
    function type  # mock jj absence
        if test "x$argv" = "x-q --no-functions jj"
            return $FAILURE
        end
    end

    _pure_prompt_jj
    set exit_status $status

    functions --erase type  # remove mock
    echo $exit_status
) -eq $ABORT_FEATURE

after_all
