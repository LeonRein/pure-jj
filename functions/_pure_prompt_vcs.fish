function _pure_prompt_vcs \
    --description 'Print version control information (Git or jj)'

    set ABORT_FEATURE 2

    if set --query pure_enable_git; and test "$pure_enable_git" != true
        return
    end

    # Prefer jj when available (exit non-zero when not in a jj repo)
    _pure_prompt_jj; or _pure_prompt_git
end
