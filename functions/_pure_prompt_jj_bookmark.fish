function _pure_prompt_jj_bookmark \
    --description "Display nearest jj bookmark name"

    set --local jj_bookmark_symbol
    set --local jj_bookmark_color

    set --local nearest_bookmark (command jj log --no-graph --ignore-working-copy -r 'heads(::@ & bookmarks())' \
        -T 'bookmarks.filter(|b| !b.remote()).map(|b| b.name()).join(", ")' 2>/dev/null)

    if test -n "$nearest_bookmark"
        set jj_bookmark_color (_pure_set_color $pure_color_jj_bookmark)
        set jj_bookmark_symbol "($nearest_bookmark)"(set_color normal)
    end

    echo "$jj_bookmark_color$jj_bookmark_symbol"
end
