set shell := ["zsh", "-c"]
set script-interpreter := ["zsh", "-e"]

# upstream repository configuration
upstream_repo := "https://github.com/iloveitaly/llm-ide-rules/blob/master"

# pull latest rules from upstream repository
pull-upstream:
    just _retrieve {{upstream_repo / ".github/instructions/python.instructions.md"}}
    just _retrieve {{upstream_repo / ".github/copilot-instructions.md"}}
    just _retrieve {{upstream_repo / ".github/prompts/standalone-python-scripts.prompt.md"}}
    llm-ide-rules implode github

[private]
[script]
_retrieve url:
    # extract the path after blob/<branch>/
    file_path=$(echo "{{url}}" | sed -E 's/.*blob\/[^\/]+\/(.*)/\1/')
    
    print "Downloading {{url}} -> $file_path"
    mkdir -p "$(dirname "$file_path")"
    http --follow --download "{{url}}?raw=true" --output "$file_path"

# sync repository metadata with github
github-repo-set-metadata:
    gh repo edit \
        --description "$(jq -r '.description' metadata.json)" \
        --homepage "$(jq -r '.homepage' metadata.json)" \
        --add-topic "$(jq -r '.keywords | join(",")' metadata.json)"