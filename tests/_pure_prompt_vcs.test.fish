source (status dirname)/fixtures/constants.fish
source (status dirname)/../functions/_pure_prompt_vcs.fish
source (status dirname)/../functions/_pure_prompt_git.fish
source (status dirname)/../functions/_pure_prompt_jj.fish

@echo (_print_filename (status filename))

function before_all
    _purge_configs
    _disable_colors

    mkdir -p /tmp/test_pure_prompt_vcs/bin
    set -gx OLD_PATH $PATH
    set -gx PATH /tmp/test_pure_prompt_vcs/bin $PATH

    cat > /tmp/test_pure_prompt_vcs/bin/jj <<'EOF'
#!/usr/bin/env fish

# Simple mock jj command used for prompt tests.
# It returns a simplified status info for specific templates.
set -l args (string join ' ' $argv)

if string match --quiet --substring 'bookmarks' "$args"
    echo main
else
    echo "🔒 abcd"
end
EOF

    chmod +x /tmp/test_pure_prompt_vcs/bin/jj
end
before_all

function after_all
    set -gx PATH $OLD_PATH
    rm -rf /tmp/test_pure_prompt_vcs
end

@test "_pure_prompt_vcs: prefers jj over git when both are available" (
    set --universal pure_enable_git true

    mkdir -p /tmp/test_pure_prompt_vcs/repo
    cd /tmp/test_pure_prompt_vcs/repo
    git init --quiet

    _pure_prompt_vcs | strip_ansi
) = '🔒 abcd (main)'

@test "_pure_prompt_vcs: displays jj status when in non-git directory" (
    set --universal pure_enable_git true

    _pure_prompt_vcs | strip_ansi
) = '🔒 abcd (main)'

after_all
