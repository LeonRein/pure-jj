function _pure_prompt_jj_status \
    --description "Display jj status flags: immutable, hidden, empty, conflict"

    set --local jj_status_symbol
    set --local jj_status_color

    set --local flags (command jj log --no-graph --ignore-working-copy -r @ \
        -T 'separate(" ", if(immutable, "immutable"), if(hidden, "hidden"), if(empty, "empty"), if(conflict, "conflict"))' \
        2>/dev/null)

    if test -n "$flags"
        set jj_status_color (_pure_set_color $pure_color_jj_status)
        set --local symbols

        for flag in (string split " " -- $flags)
            switch $flag
                case immutable
                    set --append symbols "$pure_symbol_jj_immutable"
                case hidden
                    set --append symbols "$pure_symbol_jj_hidden"
                case empty
                    set --append symbols "$pure_symbol_jj_empty"
                case conflict
                    set --append symbols "$pure_symbol_jj_conflict"
            end
        end

        if test (count $symbols) -gt 0
            set jj_status_symbol (string join " " -- $symbols)" "
        end
    end

    echo "$jj_status_color$jj_status_symbol"
end
