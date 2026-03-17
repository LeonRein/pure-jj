function _pure_prompt_vcs \
    --description 'Print version control information (Git or jj)'

    # Prefer jj when enabled; fall back to git when not in a jj repo
    _pure_prompt_jj; or _pure_prompt_git
end
