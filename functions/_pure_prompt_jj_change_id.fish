function _pure_prompt_jj_change_id \
    --description "Display jj change ID with native jj coloring for unique prefix"

    set --local change_id (command jj log --no-graph --ignore-working-copy --color always -r @ \
        -T 'change_id.shortest(4)' 2>/dev/null)

    echo "$change_id"
end
