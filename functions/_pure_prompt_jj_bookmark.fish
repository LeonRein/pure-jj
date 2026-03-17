function _pure_prompt_jj_bookmark \
    --description "Display jj bookmarks with aggregated ahead/behind indicators"

    set --local jj_bookmark
    set --local jj_ahead_behind
    set --local ahead_total 0
    set --local behind_total 0

    set --local bookmark_names (command jj log --no-graph --ignore-working-copy \
        -r '@:: & bookmarks()' \
        -T 'local_bookmarks.map(|b| b.name()).join("\n") ++ "\n"' 2>/dev/null)

    if not test -n "$bookmark_names[1]"
        set bookmark_names (command jj log --no-graph --ignore-working-copy \
            -r 'heads(::@ & bookmarks())' \
            -T 'local_bookmarks.map(|b| b.name()).join("\n") ++ "\n"' 2>/dev/null)
    end

    set bookmark_names (string split "\n" -- $bookmark_names)
    set bookmark_names (string trim -- $bookmark_names)
    set bookmark_names (string match -rv '^$' -- $bookmark_names)

    if test -n "$bookmark_names[1]"
        set --local display_bookmarks $bookmark_names[1..3]
        set --local display_name (string join ", " $display_bookmarks)
        if test (count $bookmark_names) -gt 3
            set display_name "$display_name, ..."
        end
        set --local jj_bookmark_color (_pure_set_color $pure_color_jj_bookmark)
        set jj_bookmark "$jj_bookmark_color($display_name)"(set_color normal)

        # Query and sum ahead/behind counts for the first three displayed bookmarks.
        for bookmark_name in $display_bookmarks
            set --local tracking_info (command jj log --no-graph --ignore-working-copy \
                -r "latest(remote_bookmarks($bookmark_name), 1)" \
                -T 'remote_bookmarks.first().tracking_behind_count().lower() ++ "\n" ++ remote_bookmarks.first().tracking_ahead_count().lower()' 2>/dev/null)

            set --local ahead_count "$tracking_info[1]"
            set --local behind_count "$tracking_info[2]"

            if string match -qr '^[0-9]+$' -- "$ahead_count"
                set ahead_total (math "$ahead_total + $ahead_count")
            end

            if string match -qr '^[0-9]+$' -- "$behind_count"
                set behind_total (math "$behind_total + $behind_count")
            end
        end
    end

    if test $ahead_total -gt 0
        set --local jj_ahead_color (_pure_set_color $pure_color_jj_ahead)
        set --append jj_ahead_behind "$jj_ahead_color$pure_symbol_jj_ahead"
        if test "$pure_show_numbered_jj_indicator" = true
            set jj_ahead_behind "$jj_ahead_behind$ahead_total"
        end
    end

    if test $behind_total -gt 0
        set --local jj_behind_color (_pure_set_color $pure_color_jj_behind)
        set jj_ahead_behind "$jj_ahead_behind$jj_behind_color$pure_symbol_jj_behind"
        if test "$pure_show_numbered_jj_indicator" = true
            set jj_ahead_behind "$jj_ahead_behind$behind_total"
        end
    end

    set --local result
    if test -n "$jj_bookmark"
        set --append result "$jj_bookmark"
    end
    if test -n "$jj_ahead_behind"
        set --append result "$jj_ahead_behind"
    end

    echo $result
end
