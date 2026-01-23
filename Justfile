set shell := ["zsh", "-uc"]

# upstream repository configuration
upstream_repo := "https://github.com/iloveitaly/llm-ide-rules/blob/master"

# pull latest rules from upstream repository
pull-upstream:
    just _retrieve {{upstream_repo / ".github/instructions/python.instructions.md"}}
    just _retrieve {{upstream_repo / ".github/copilot-instructions.md"}}

[private]
[script]
_retrieve url:
    # extract the path after blob/<branch>/
    path=$(echo "{{url}}" | sed -E 's/.*blob\/[^\/]+\/(.*)/\1/')
    
    print "Downloading {{url}} -> $path"
    mkdir -p "$(dirname "$path")"
    http --follow --download "{{url}}?raw=true" --output "$path"