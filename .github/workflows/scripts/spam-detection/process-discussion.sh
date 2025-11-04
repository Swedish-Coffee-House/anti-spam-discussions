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

_result="$("$SPAM_DIR/check-discussion.sh" "$_discussion_url")"

if [[ "$_result" == "PASS" ]]; then
    echo "detected as not-spam: $_discussion_url"
    exit 0
fi

echo "detected as spam: $_discussion_url"

# Extract discussion number from URL
_discussion_number=$(echo "$_discussion_url" | grep -oP '/discussions/\K[0-9]+')

# Get repository owner and name from URL
_owner=$(echo "$_discussion_url" | sed -n 's|https://github.com/\([^/]*\)/.*|\1|p')
_name=$(echo "$_discussion_url" | sed -n 's|https://github.com/[^/]*/\([^/]*\)/.*|\1|p')

# First, get the discussion ID (node ID)
_discussion_id=$(gh api graphql \
  -F owner="$_owner" \
  -F name="$_name" \
  -F number="$_discussion_number" \
  -f query='
    query($owner: String!, $name: String!, $number: Int!) {
      repository(owner: $owner, name: $name) {
        discussion(number: $number) {
          id
        }
      }
    }
  ' --jq '.data.repository.discussion.id')

# Create the comment message
_comment_body="Thank you for taking the time to create this discussion.

We've automatically reviewed this discussion and suspect it as potentially inauthentic or spam-like content. As a result, we're marking this discussion.

**If this was flagged by mistake**, please don't hesitate to reach out to the moderators or repository maintainers by commenting on this discussion with additional context.

We appreciate your understanding and apologize if this action was taken in error. Our automated systems help us manage the large volume of discussions we receive, but we know they're not perfect."

# Add a comment to the discussion
gh api graphql \
  -F discussionId="$_discussion_id" \
  -F body="$_comment_body" \
  -f query='
    mutation($discussionId: ID!, $body: String!) {
      addDiscussionComment(input: {discussionId: $discussionId, body: $body}) {
        comment {
          id
        }
      }
    }
  ' --silent || echo "Warning: Could not add comment to discussion"

echo "discussion processed as suspected spam: commented and flagged"
