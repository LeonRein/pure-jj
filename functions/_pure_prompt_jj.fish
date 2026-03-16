function _pure_prompt_jj \
    --description 'Print jj repository information: change id, status flags, and nearest bookmark'

    set ABORT_FEATURE 2

    if set --query pure_enable_git; and test "$pure_enable_git" != true
        return
    end

    if not type -q --no-functions jj
        return $ABORT_FEATURE
    end

    set --local status_info (command jj log --no-graph --ignore-working-copy --color always -r @ -T '
        separate(" ",
            if(immutable, label("immutable", "🔒")),
            if(hidden, label("hidden", "👻")),
            if(empty, label("empty", "∅")),
            label("change_id", change_id.shortest(4)),
            if(conflict, label("conflict", "💥"))
        )
    ' 2>/dev/null)

    test -z "$status_info"; and return 1

    set --local nearest_bookmark (command jj log --no-graph --ignore-working-copy -r 'heads(::@ & bookmarks())' -T 'bookmarks.map(|b| b.name()).join(", ")' 2>/dev/null)
    set --local pure_gray (_pure_set_color 93a1a1)

    if test -n "$nearest_bookmark"
        echo "$status_info $pure_gray($nearest_bookmark)"(set_color normal)
    else
        echo "$status_info"
    end
end
