# Usage Guide

## Quick Start

This repository provides automated spam detection for GitHub Discussions. Once set up, it will automatically analyze new discussions and flag potential spam.

## Prerequisites

1. **Enable GitHub Discussions** in your repository settings
2. **Enable GitHub Models** for your repository (if not already available)
3. Ensure you have the necessary permissions in your repository

## Installation

### For This Repository

The workflow is already set up! It will automatically:
- Monitor new discussions
- Analyze them using AI
- Minimize (hide) suspicious content marked as spam

### For Your Own Repository

To use this in your own repository:

1. **Copy the workflow files**:
   ```bash
   # Clone this repository
   git clone https://github.com/Swedish-Coffee-House/anti-spam-discussions.git
   
   # Copy the .github directory to your repository
   cp -r anti-spam-discussions/.github /path/to/your/repo/
   ```

2. **Commit and push**:
   ```bash
   cd /path/to/your/repo
   git add .github
   git commit -m "Add spam detection workflow for Discussions"
   git push
   ```

3. **Verify the workflow**:
   - Go to your repository's Actions tab
   - You should see "Spam Discussion Detection" workflow listed
   - Create a test discussion to verify it works

## How It Works

### Detection Process

1. **Trigger**: A new discussion is created
2. **Analysis**: The workflow fetches the discussion title, body, and any comments
3. **AI Evaluation**: Content is analyzed using GPT-4o-mini
4. **Action**: If spam is detected, the discussion is minimized (hidden) and marked as spam

### What Gets Detected

The AI model looks for:
- Very short or empty content
- Gibberish or meaningless text
- Links without context
- Promotional content
- Repetitive text
- Off-topic content
- Template content that hasn't been filled in

## Customization

### Adjust Spam Criteria

Edit `.github/workflows/scripts/spam-detection/generate-sys-prompt.sh` to modify what the AI considers as spam:

```bash
# Add new spam indicators
- Your new spam pattern here

# Or modify existing ones
- A body that contains only a single word or a few words without context
```

### Change the AI Model

Edit `.github/workflows/scripts/spam-detection/check-discussion-prompts.yml`:

```yaml
name: Detect spam
model: openai/gpt-4o-mini  # Change to another available model
```

### Change the Spam Classifier

Edit `.github/workflows/scripts/spam-detection/process-discussion.sh` to change how spam is marked:

```bash
# Available classifiers: SPAM, OUTDATED, OFF_TOPIC, RESOLVED, DUPLICATE, ABUSE
-F classifier="SPAM"  # Change to another classifier if needed
```

### Take Additional Actions

You can extend `process-discussion.sh` to:
- Use different classifiers (OUTDATED, OFF_TOPIC, etc.)
- Send notifications to moderators
- Log to external systems
- Add additional checks before minimizing

## Testing

### Test the AI Model

Run the evaluation script to test the spam detection:

```bash
# From the repository root
./.github/workflows/scripts/spam-detection/eval.sh
```

This will test the model against predefined test cases.

### Add Your Own Test Cases

Edit `.github/workflows/scripts/spam-detection/eval-prompts.yml` to add test cases:

```yaml
testData:
  - name: your test case name
    expected: FAIL  # or PASS
    input: |
      <TITLE>
      Test Title
      </TITLE>

      <BODY>
      Test body content
      </BODY>
```

## Troubleshooting

### Workflow Not Triggering

1. Check that Discussions are enabled in repository settings
2. Verify the workflow file is in `.github/workflows/`
3. Check Actions tab for any errors

### False Positives

If legitimate discussions are being flagged:

1. Review the flagged content
2. Adjust the spam criteria in `generate-sys-prompt.sh`
3. Add similar legitimate content to test cases
4. Re-run evaluation to verify improvements

### API Errors

If you see errors about GitHub Models:

1. Verify GitHub Models is enabled for your repository
2. Check that the `GH_TOKEN` has the necessary permissions
3. Ensure the `models: read` permission is set in the workflow

## Monitoring

### View Workflow Runs

1. Go to your repository's **Actions** tab
2. Click on **Spam Discussion Detection**
3. View individual runs to see:
   - Which discussions were analyzed
   - Detection results
   - Any errors

### Review Flagged Discussions

1. Discussions flagged as spam will be minimized (hidden)
2. Review the minimized discussion content
3. If it's a false positive:
   - Un-minimize the discussion in GitHub's UI
   - Consider adjusting the detection criteria

## Best Practices

1. **Monitor Initially**: When first deployed, check minimized discussions frequently
2. **Tune Gradually**: Adjust criteria based on your community's patterns
3. **Be Transparent**: Consider adding a pinned discussion explaining automated moderation
4. **Human Review**: Always have moderators review minimized content
5. **Iterate**: Update test cases and criteria as spam patterns evolve

## Advanced Usage

### Multiple Repositories

To use across multiple repositories in an organization:

1. Create a template repository with the workflow
2. Use it as a template when creating new repositories
3. Or use GitHub's repository sync tools

### Integration with Other Tools

The workflow can be extended to integrate with:
- Slack/Discord notifications
- Issue tracking systems
- Analytics platforms
- Custom moderation dashboards

### Custom Actions

Modify `process-discussion.sh` to take different actions:

```bash
# Example: Send to moderation queue instead of minimizing
# (This is pseudocode - implement as needed)
if [[ "$_result" == "FAIL" ]]; then
    send_to_moderation_queue "$_discussion_url"
fi
```

## Getting Help

If you encounter issues:

1. Check the [README](README.md) for general information
2. Review workflow run logs in the Actions tab
3. Open an issue in this repository
4. Review GitHub's documentation on:
   - [GitHub Actions](https://docs.github.com/en/actions)
   - [GitHub Discussions](https://docs.github.com/en/discussions)
   - [GitHub Models](https://docs.github.com/en/github-models)

## Contributing

To improve the spam detection:

1. Fork this repository
2. Make your changes
3. Test thoroughly with various content
4. Submit a pull request with:
   - Description of changes
   - Test results
   - Example discussions that benefit from the change
