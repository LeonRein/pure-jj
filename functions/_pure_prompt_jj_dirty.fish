function _pure_prompt_jj_dirty \
    --description "Display jj dirty indicator when working copy has changes"

    set --local jj_dirty_symbol
    set --local jj_dirty_color

    set --local is_dirty (command jj log --no-graph --ignore-working-copy -r @ \
        -T 'if(!empty, "dirty")' 2>/dev/null)

    if test -n "$is_dirty"
        set jj_dirty_symbol "$pure_symbol_jj_dirty"
        set jj_dirty_color (_pure_set_color $pure_color_jj_dirty)
    end

    echo "$jj_dirty_color$jj_dirty_symbol"
end
