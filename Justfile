# there are a set of instructions that I'd like to pull from upstream rules
pull-upstream:
  just github_retrieve_raw https://github.com/iloveitaly/llm-ide-rules/blob/master/.github/instructions/python.instructions.md
  just github_retrieve_raw https://github.com/iloveitaly/llm-ide-rules/blob/master/.github/copilot-instructions.md

github_retrieve_raw url:
  #!/usr/bin/env bash
  set -euo pipefail
  # extract the path after blob/<branch>/
  path=$(echo "{{url}}" | sed -E 's/.*blob\/[^\/]+\/(.*)/\1/')
  mkdir -p "$(dirname "$path")"
  http --follow --download "{{url}}?raw=true" --output "$path"