function _pure_prompt_vcs \
    --description 'Print version control information (Git or jj)'

    if set --query pure_enable_git; and test "$pure_enable_git" != true
        if set --query pure_enable_jj; and test "$pure_enable_jj" != true
            return
        end
    end

    # Prefer jj when available (exit non-zero when not in a jj repo)
    _pure_prompt_jj; or _pure_prompt_git
end
