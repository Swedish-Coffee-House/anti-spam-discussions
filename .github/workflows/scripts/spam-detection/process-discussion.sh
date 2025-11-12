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

# Minimize the comment as spam
gh api graphql \
  -F subjectId="$_comment_node_id" \
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
  ' --silent || echo "Warning: Could not minimize comment"

echo "comment processed as suspected spam: minimized as spam"
