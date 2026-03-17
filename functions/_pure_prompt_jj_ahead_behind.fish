function _pure_prompt_jj_ahead_behind \
    --description "Display jj changes ahead of or behind the nearest bookmark"

    set --local jj_ahead
    set --local jj_behind

    set --local bookmark_names (command jj log --no-graph --ignore-working-copy \
        -r 'heads(::@ & bookmarks())' \
        -T 'bookmarks.filter(|b| !b.remote()).map(|b| b.name()).join("\n")' 2>/dev/null)
    set --local bookmark_name $bookmark_names[1]

    if test -n "$bookmark_name"
        # Ahead: changes in @ not yet in the bookmark (local changes to push)
        set --local ahead_revs (command jj log --no-graph --ignore-working-copy \
            -r "$bookmark_name..@" -T '".\n"' 2>/dev/null)
        set --local ahead_count (count $ahead_revs)

        if test "$ahead_count" -gt 0
            set --local jj_ahead_color (_pure_set_color $pure_color_jj_ahead)
            set jj_ahead "$jj_ahead_color$pure_symbol_jj_ahead"
            if test "$pure_show_numbered_jj_indicator" = true
                set jj_ahead "$jj_ahead$ahead_count"
            end
        end

        # Behind: changes on the remote tracking bookmark not in @ (remote changes to pull)
        set --local behind_revs (command jj log --no-graph --ignore-working-copy \
            -r "@..$bookmark_name@origin" -T '".\n"' 2>/dev/null)
        set --local behind_count (count $behind_revs)

        if test "$behind_count" -gt 0
            set --local jj_behind_color (_pure_set_color $pure_color_jj_behind)
            set jj_behind "$jj_behind_color$pure_symbol_jj_behind"
            if test "$pure_show_numbered_jj_indicator" = true
                set jj_behind "$jj_behind$behind_count"
            end
        end
    end

    echo "$jj_ahead$jj_behind"
end
