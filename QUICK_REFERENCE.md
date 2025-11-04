# Quick Reference

## Overview
Automated spam detection for GitHub Discussions using GitHub Models.

## Key Files

| File | Purpose |
|------|---------|
| `.github/workflows/detect-spam-discussions.yml` | Main workflow triggered on new discussions |
| `check-discussion.sh` | Core spam detection logic |
| `process-discussion.sh` | Handles flagged discussions |
| `generate-sys-prompt.sh` | Generates AI prompt with spam criteria |
| `check-discussion-prompts.yml` | AI model configuration |
| `eval-prompts.yml` | Test cases for validation |
| `eval.sh` | Runs test suite |

## Quick Commands

### Test the System
```bash
# Run evaluation tests
./.github/workflows/scripts/spam-detection/eval.sh

# Check a specific discussion manually
./.github/workflows/scripts/spam-detection/check-discussion.sh <discussion-url>

# Process a discussion (minimizes if spam)
./.github/workflows/scripts/spam-detection/process-discussion.sh <discussion-url>
```

### Customize Detection

**Edit spam criteria:**
```bash
vim .github/workflows/scripts/spam-detection/generate-sys-prompt.sh
```

**Change AI model:**
```bash
vim .github/workflows/scripts/spam-detection/check-discussion-prompts.yml
# Change: model: openai/gpt-4o-mini
```

**Change spam classifier:**
```bash
vim .github/workflows/scripts/spam-detection/process-discussion.sh
# Change: -F classifier="SPAM" to OUTDATED, OFF_TOPIC, etc.
```

## Workflow Trigger

```yaml
on:
  discussion:
    types: [created]
```

## Permissions Required

```yaml
permissions:
  contents: read      # To checkout repository
  discussions: write  # To minimize discussions
  models: read        # To use GitHub Models API
```

## How It Works

1. **New discussion created** → Workflow triggers
2. **Fetch discussion** → Title and body extracted via GraphQL
3. **AI analysis** → Content evaluated against spam criteria
4. **Result: PASS** → Discussion allowed (no action)
5. **Result: FAIL** → Discussion minimized (hidden) and marked as spam

## Spam Indicators

✗ Empty/very short body  
✗ Gibberish text  
✗ Links without context  
✗ Promotional content  
✗ Repetitive text  
✗ Off-topic content  
✗ Unfilled templates  

## Legitimate Indicators

✓ Clear questions with context  
✓ Detailed bug reports  
✓ Feature requests with explanations  
✓ Community discussions  
✓ Technical troubleshooting  
✓ Documentation questions  

## Environment Variables

| Variable | Purpose |
|----------|---------|
| `GH_TOKEN` | GitHub token for API access |
| `DISCUSSION_URL` | URL of the discussion to check |

## Dependencies

- **gh CLI**: GitHub command-line tool
- **yq**: YAML processor
- **gh-models**: GitHub Models extension for gh CLI

## Common Issues

**Workflow not triggering:**
- Verify Discussions are enabled
- Check workflow file location
- Review Actions permissions

**False positives:**
- Adjust criteria in `generate-sys-prompt.sh`
- Add test cases
- Re-run evaluation

**API errors:**
- Verify GitHub Models access
- Check token permissions
- Review workflow logs

## URLs and Resources

- [GitHub Models](https://docs.github.com/en/github-models)
- [GitHub Discussions](https://docs.github.com/en/discussions)
- [GitHub Actions](https://docs.github.com/en/actions)
- [Reference Implementation](https://github.com/cli/cli/tree/trunk/.github/workflows/scripts/spam-detection)

## Support

- See [USAGE.md](USAGE.md) for detailed guide
- See [EXAMPLES.md](EXAMPLES.md) for detection examples
- See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution info
- Open an issue for problems or questions
