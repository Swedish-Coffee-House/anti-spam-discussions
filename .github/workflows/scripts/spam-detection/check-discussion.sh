#!/bin/bash

# Check if a discussion is spam or not and output "PASS" (not spam) or "FAIL" (spam).
#
# Regardless of the spam detection result, the script always exits with a zero
# exit code, unless there's a runtime error.
#
# This script must be run from the root directory of the repository.

set -euo pipefail

# Determine absolute path to script directory based on where it is called from.
# This allows the script to be run from any directory.
SPAM_DIR="$(dirname "$(realpath "$0")")"

# Retrieve and prepare information about discussion for detection
_discussion_url="$1"
if [[ -z "$_discussion_url" ]]; then
    echo "error: discussion URL is empty" >&2
    exit 1
fi

# Extract discussion number from URL
_discussion_number=$(echo "$_discussion_url" | grep -oP '/discussions/\K[0-9]+')

# Get repository owner and name from URL
_owner=$(echo "$_discussion_url" | sed -n 's|https://github.com/\([^/]*\)/.*|\1|p')
_name=$(echo "$_discussion_url" | sed -n 's|https://github.com/[^/]*/\([^/]*\)/.*|\1|p')

# Fetch discussion data including comments using GraphQL
_user_prompt=$(gh api graphql \
  -F owner="$_owner" \
  -F name="$_name" \
  -F number="$_discussion_number" \
  -f query='
    query($owner: String!, $name: String!, $number: Int!) {
      repository(owner: $owner, name: $name) {
        discussion(number: $number) {
          title
          body
          comments(first: 100) {
            nodes {
              body
              author {
                login
              }
            }
          }
        }
      }
    }
  ' --jq '
    .data.repository.discussion as $d |
    "<TITLE>\n" + $d.title + "\n</TITLE>\n\n<BODY>\n" + ($d.body // "") + "\n</BODY>" +
    (if ($d.comments.nodes | length) > 0 then
      "\n\n<COMMENTS>\n" +
      ([$d.comments.nodes[] | "Author: " + .author.login + "\n" + .body] | join("\n---\n")) +
      "\n</COMMENTS>"
    else "" end)
  ')

# Generate dynamic prompts for inference
_system_prompt="$($SPAM_DIR/generate-sys-prompt.sh)"
_final_prompt="$(_system="$_system_prompt" _user="$_user_prompt" yq eval ".messages[0].content = strenv(_system) | .messages[1].content = strenv(_user)" "$SPAM_DIR/check-discussion-prompts.yml")"

gh extension install github/gh-models 2>/dev/null || true

_result="$(gh models run --file <(echo "$_final_prompt") | cat)"

if [[ "$_result" != "PASS" && "$_result" != "FAIL" ]]; then
    echo "error: expected PASS or FAIL but got an unexpected result: $_result" >&2
    exit 1
fi

echo "$_result"
