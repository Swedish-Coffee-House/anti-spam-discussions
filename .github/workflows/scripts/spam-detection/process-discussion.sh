#!/bin/bash

# Performs spam detection on a discussion and marks it if it's spam.
#
# Regardless of the spam detection result, the script always exits with a zero
# exit code, unless there's a runtime error.
#
# This script must be run from the root directory of the repository.

set -euo pipefail

# Determine absolute path to script directory based on where it is called from.
# This allows the script to be run from any directory.
SPAM_DIR="$(dirname "$(realpath "$0")")"

_discussion_url="$1"
if [[ -z "$_discussion_url" ]]; then
    echo "error: discussion URL is empty" >&2
    exit 1
fi

_comment_node_id="$2"
_comment_body="$3"

_result="$("$SPAM_DIR/check-discussion.sh" "$_discussion_url" "$_comment_node_id" "$_comment_body")"

if [[ "$_result" == "PASS" ]]; then
    echo "detected as not-spam: $_discussion_url"
    exit 0
fi

echo "detected as spam: $_discussion_url"

# Use the comment node ID if provided, otherwise fetch the discussion body ID
if [[ -n "$_comment_node_id" ]]; then
    _comment_id="$_comment_node_id"
else
    # Extract discussion number from URL
    _discussion_number=$(echo "$_discussion_url" | grep -oP '/discussions/\K[0-9]+')

    # Get repository owner and name from URL
    _owner=$(echo "$_discussion_url" | sed -n 's|https://github.com/\([^/]*\)/.*|\1|p')
    _name=$(echo "$_discussion_url" | sed -n 's|https://github.com/[^/]*/\([^/]*\)/.*|\1|p')

    # First, get the discussion body comment ID (node ID)
    # The first comment in a discussion is the discussion body itself
    _comment_id=$(gh api graphql \
      -F owner="$_owner" \
      -F name="$_name" \
      -F number="$_discussion_number" \
      -f query='
        query($owner: String!, $name: String!, $number: Int!) {
          repository(owner: $owner, name: $name) {
            discussion(number: $number) {
              body
              id
            }
          }
        }
      ' --jq '.data.repository.discussion.id')
fi

# Minimize the discussion comment as spam
gh api graphql \
  -F subjectId="$_comment_id" \
  -F classifier="SPAM" \
  -f query='
    mutation($subjectId: ID!, $classifier: ReportedContentClassifiers!) {
      minimizeComment(input: {subjectId: $subjectId, classifier: $classifier}) {
        minimizedComment {
          isMinimized
          minimizedReason
        }
      }
    }
  ' --silent || echo "Warning: Could not minimize discussion"

echo "comment processed as suspected spam: minimized as spam"
