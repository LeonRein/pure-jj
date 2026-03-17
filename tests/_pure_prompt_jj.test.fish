source (status dirname)/fixtures/constants.fish
source (status dirname)/../functions/_pure_prompt_jj.fish
source (status dirname)/../functions/_pure_prompt_jj_change_id.fish
source (status dirname)/../functions/_pure_prompt_jj_status.fish
source (status dirname)/../functions/_pure_prompt_jj_bookmark.fish
source (status dirname)/../functions/_pure_prompt_jj_dirty.fish
source (status dirname)/../functions/_pure_string_width.fish
@echo (_print_filename (status filename))


function before_each
    mkdir -p /tmp/test_pure_prompt_jj/bin
    set -gx OLD_PATH $PATH
    set -gx PATH /tmp/test_pure_prompt_jj/bin $PATH

    # Mock jj command that handles 'root' subcommand
    printf '%s\n' '#!/bin/sh' \
        'if [ "$1" = "root" ]; then' \
        '    echo "/tmp/test_pure_prompt_jj"' \
        'fi' > /tmp/test_pure_prompt_jj/bin/jj
    chmod +x /tmp/test_pure_prompt_jj/bin/jj

    _purge_configs
    _disable_colors
end

function after_each
    set -gx PATH $OLD_PATH
    rm -rf /tmp/test_pure_prompt_jj
end


before_each
@test "_pure_prompt_jj: fails when jj is missing" (
    set --universal pure_enable_jj true
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
after_each

before_each
@test "_pure_prompt_jj: ignores directory that is not jj repository" (
    # Mock jj that fails on 'root'
    printf '%s\n' '#!/bin/sh' 'exit 1' > /tmp/test_pure_prompt_jj/bin/jj
    chmod +x /tmp/test_pure_prompt_jj/bin/jj

    function _pure_prompt_jj_status; echo $EMPTY; end
    function _pure_prompt_jj_change_id; echo $EMPTY; end
    function _pure_prompt_jj_dirty; echo $EMPTY; end
    function _pure_prompt_jj_bookmark; echo $EMPTY; end

    _pure_prompt_jj
) $status -eq $SUCCESS
after_each

before_each
@test "_pure_prompt_jj: activates on jj repository" (
    function _pure_prompt_jj_status; echo $EMPTY; end
    function _pure_prompt_jj_change_id; echo "abcd"; end
    function _pure_prompt_jj_dirty; echo $EMPTY; end
    function _pure_prompt_jj_bookmark; echo $EMPTY; end

    set --universal pure_enable_jj true

    _pure_prompt_jj
) = abcd
after_each

before_each
@test "_pure_prompt_jj: shows status flags with change id" (
    function _pure_prompt_jj_status; echo "🔒 "; end
    function _pure_prompt_jj_change_id; echo "abcd"; end
    function _pure_prompt_jj_dirty; echo $EMPTY; end
    function _pure_prompt_jj_bookmark; echo $EMPTY; end

    set --universal pure_enable_jj true

    _pure_prompt_jj
) = '🔒 abcd'
after_each

before_each
@test "_pure_prompt_jj: shows dirty indicator" (
    function _pure_prompt_jj_status; echo $EMPTY; end
    function _pure_prompt_jj_change_id; echo "abcd"; end
    function _pure_prompt_jj_dirty; echo '*'; end
    function _pure_prompt_jj_bookmark; echo $EMPTY; end

    set --universal pure_enable_jj true

    _pure_prompt_jj
) = 'abcd*'
after_each

before_each
@test "_pure_prompt_jj: shows bookmark" (
    function _pure_prompt_jj_status; echo $EMPTY; end
    function _pure_prompt_jj_change_id; echo "abcd"; end
    function _pure_prompt_jj_dirty; echo $EMPTY; end
    function _pure_prompt_jj_bookmark; echo '(main)'; end

    set --universal pure_enable_jj true

    _pure_prompt_jj
) = 'abcd (main)'
after_each

before_each
@test "_pure_prompt_jj: shows full prompt with all components" (
    function _pure_prompt_jj_status; echo "🔒 "; end
    function _pure_prompt_jj_change_id; echo "abcd"; end
    function _pure_prompt_jj_dirty; echo '*'; end
    function _pure_prompt_jj_bookmark; echo '(main)'; end

    set --universal pure_enable_jj true

    _pure_prompt_jj
) = '🔒 abcd* (main)'
after_each

before_each
@test "_pure_prompt_jj: returns empty when pure_enable_jj is false" (
    function _pure_prompt_jj_status; echo $EMPTY; end
    function _pure_prompt_jj_change_id; echo "abcd"; end
    function _pure_prompt_jj_dirty; echo $EMPTY; end
    function _pure_prompt_jj_bookmark; echo $EMPTY; end

    set --universal pure_enable_jj false

    _pure_prompt_jj
) $status -eq $FAILURE
after_each
