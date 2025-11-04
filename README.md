# anti-spam-discussions

Automated spam detection for GitHub Discussions using GitHub Models and GitHub Actions.

## Overview

This repository provides an automated spam detection system for GitHub Discussions, inspired by the [GitHub CLI spam detection implementation](https://github.com/cli/cli/tree/trunk/.github/workflows/scripts/spam-detection). It uses AI-powered analysis through GitHub Models to identify and flag potentially spam discussions.

## Features

- **Automatic Detection**: Analyzes new discussions when they are created
- **AI-Powered**: Uses OpenAI's GPT-4o-mini model via GitHub Models
- **Non-Destructive**: Adds comments to suspected spam discussions rather than deleting them
- **Transparent**: Includes explanation in comments allowing for appeals
- **Customizable**: Easy to adjust spam detection criteria

## How It Works

When a new discussion is created in your repository:

1. The GitHub Actions workflow is triggered
2. The discussion title and body are extracted
3. An AI model analyzes the content using predefined spam indicators
4. If spam is detected, a comment is added to the discussion explaining the situation
5. Repository maintainers can review and take appropriate action

## Spam Detection Criteria

The system looks for common spam patterns including:

- Empty or very short bodies with no meaningful content
- Unrelated or gibberish text
- Links without context or explanation
- Promotional content
- Copy-pasted content without proper context
- Template-like content that hasn't been filled in
- Single words or very low-effort posts

## Setup

### Prerequisites

1. **GitHub Models Access**: Your repository needs access to GitHub Models
2. **Enable Discussions**: GitHub Discussions must be enabled for your repository
3. **Permissions**: The workflow requires `discussions: write` and `models: read` permissions

### Installation

1. Copy the `.github` directory to your repository
2. Ensure the workflow has the necessary permissions (already configured in the workflow file)
3. The workflow will automatically run on new discussions

### Configuration

The spam detection behavior can be customized by editing:

- **System Prompt**: `.github/workflows/scripts/spam-detection/generate-sys-prompt.sh` - Modify spam detection criteria
- **AI Model**: `.github/workflows/scripts/spam-detection/check-discussion-prompts.yml` - Change the AI model
- **Comment Message**: `.github/workflows/scripts/spam-detection/process-discussion.sh` - Customize the message posted to spam discussions

## Testing

You can test the spam detection model using the evaluation script:

```bash
# Install gh CLI if not already installed
# Install the gh-models extension
gh extension install github/gh-models

# Run the evaluation tests
./.github/workflows/scripts/spam-detection/eval.sh
```

This will run the AI model against test cases to verify it's working correctly.

## Files Structure

```
.github/
├── workflows/
│   ├── detect-spam-discussions.yml          # GitHub Actions workflow
│   └── scripts/
│       └── spam-detection/
│           ├── check-discussion.sh           # Main spam detection logic
│           ├── check-discussion-prompts.yml  # AI model configuration
│           ├── eval.sh                       # Test runner
│           ├── eval-prompts.yml             # Test cases
│           ├── generate-sys-prompt.sh        # System prompt generator
│           └── process-discussion.sh         # Discussion processing and commenting
```

## Privacy and Security

- The system only analyzes publicly visible discussion content
- No data is stored or sent to external services beyond GitHub's infrastructure
- GitHub Models API is used which follows GitHub's privacy policies

## Limitations

- The AI model may occasionally misclassify content (false positives/negatives)
- The system relies on GitHub Models API availability
- Requires active monitoring by maintainers to handle edge cases

## Credits

This implementation is based on:
- [GitHub CLI spam detection scripts](https://github.com/cli/cli/tree/trunk/.github/workflows/scripts/spam-detection)
- [GitHub Models for maintainers](https://github.blog/open-source/maintainers/how-github-models-can-help-open-source-maintainers-focus-on-what-matters/)

## License

This project follows the same principles as the reference implementation from GitHub CLI.