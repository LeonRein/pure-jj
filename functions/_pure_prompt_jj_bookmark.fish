function _pure_prompt_jj_bookmark \
    --description "Display nearest jj bookmark name with ahead/behind indicators"

    set --local jj_bookmark
    set --local jj_ahead_behind

    set --local bookmark_names (command jj log --no-graph --ignore-working-copy \
        -r 'heads((::@ | @::) & bookmarks())' \
        -T 'local_bookmarks.map(|b| b.name()).join("\n")' 2>/dev/null)

    if test -n "$bookmark_names[1]"
        set --local display_name (string join ", " $bookmark_names)
        set --local jj_bookmark_color (_pure_set_color $pure_color_jj_bookmark)
        set jj_bookmark "$jj_bookmark_color($display_name)"(set_color normal)

        # Query ahead/behind counts from remote tracking bookmark
        set --local bookmark_name $bookmark_names[1]
        set --local tracking_info (command jj log --no-graph --ignore-working-copy \
            -r "latest(remote_bookmarks($bookmark_name), 1)" \
            -T 'remote_bookmarks.first().tracking_ahead_count().lower() ++ "\n" ++ remote_bookmarks.first().tracking_behind_count().lower()' 2>/dev/null)

        set --local ahead_count "$tracking_info[1]"
        set --local behind_count "$tracking_info[2]"

        if test -n "$ahead_count" -a "$ahead_count" -gt 0 2>/dev/null
            set --local jj_ahead_color (_pure_set_color $pure_color_jj_ahead)
            set --append jj_ahead_behind "$jj_ahead_color$pure_symbol_jj_ahead"
            if test "$pure_show_numbered_jj_indicator" = true
                set jj_ahead_behind "$jj_ahead_behind$ahead_count"
            end
        end

        if test -n "$behind_count" -a "$behind_count" -gt 0 2>/dev/null
            set --local jj_behind_color (_pure_set_color $pure_color_jj_behind)
            set jj_ahead_behind "$jj_ahead_behind$jj_behind_color$pure_symbol_jj_behind"
            if test "$pure_show_numbered_jj_indicator" = true
                set jj_ahead_behind "$jj_ahead_behind$behind_count"
            end
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
