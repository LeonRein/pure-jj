function _pure_prompt_jj \
    --description 'Print jj repository information: status flags, change id, dirty, and nearest bookmark'

    set ABORT_FEATURE 2

    if set --query pure_enable_jj; and test "$pure_enable_jj" != true
        return 1
    end

    if not type -q --no-functions jj
        return $ABORT_FEATURE
    end

    set --local is_jj_repository (command jj root --ignore-working-copy 2>/dev/null)

    if test -z "$is_jj_repository"
        return 1
    end

    set --local jj_prompt (_pure_prompt_jj_status)(_pure_prompt_jj_change_id)(_pure_prompt_jj_dirty)
    set --local jj_bookmark (_pure_prompt_jj_bookmark)

    if test (_pure_string_width "$jj_bookmark") -ne 0
        set --append jj_prompt $jj_bookmark
    end

    echo $jj_prompt
end
