# Contributing to Anti-Spam Discussions

Thank you for your interest in improving spam detection for GitHub Discussions!

## How to Contribute

### Reporting Issues

If you encounter problems or have suggestions:

1. Check existing issues to avoid duplicates
2. Create a new issue with:
   - Clear description of the problem or suggestion
   - Steps to reproduce (if reporting a bug)
   - Expected vs actual behavior
   - Examples of discussions that demonstrate the issue

### Improving Spam Detection

The most valuable contributions involve improving detection accuracy:

#### 1. Report False Positives/Negatives

When the system incorrectly flags content:

1. Document the case in an issue
2. Include the discussion title and body
3. Explain why the detection was incorrect
4. Suggest improvements to the criteria

#### 2. Add Test Cases

Help improve the test suite:

1. Edit `.github/workflows/scripts/spam-detection/eval-prompts.yml`
2. Add real-world examples from your experience
3. Ensure a mix of spam and legitimate content
4. Run tests: `./.github/workflows/scripts/spam-detection/eval.sh`

Example test case:
```yaml
- name: description of the case
  expected: FAIL  # or PASS for legitimate content
  input: |
    <TITLE>
    Discussion title
    </TITLE>

    <BODY>
    Discussion body
    </BODY>
```

#### 3. Improve Detection Criteria

Enhance the AI prompt in `generate-sys-prompt.sh`:

1. Add new spam patterns you've observed
2. Refine existing descriptions
3. Add context that helps the AI understand edge cases
4. Test changes with the eval script

### Code Contributions

#### Setting Up Development Environment

```bash
# Clone the repository
git clone https://github.com/Swedish-Coffee-House/anti-spam-discussions.git
cd anti-spam-discussions

# Install dependencies
# - gh CLI: https://cli.github.com/
# - yq: https://github.com/mikefarah/yq
# - GitHub Models extension: gh extension install github/gh-models

# Make your changes
# Test your changes
./.github/workflows/scripts/spam-detection/eval.sh
```

#### Code Style

- Follow existing script patterns
- Use `set -euo pipefail` in bash scripts
- Add comments for complex logic
- Keep scripts modular and focused

#### Testing Changes

Before submitting:

1. **Syntax Check**: Ensure scripts have no syntax errors
   ```bash
   bash -n script.sh
   ```

2. **Run Evaluations**: Test against the eval suite
   ```bash
   ./.github/workflows/scripts/spam-detection/eval.sh
   ```

3. **Manual Testing**: Test with real discussions if possible
   ```bash
   ./.github/workflows/scripts/spam-detection/check-discussion.sh <discussion-url>
   ```

### Submitting Changes

1. **Fork** the repository
2. **Create a branch** for your changes:
   ```bash
   git checkout -b improve-detection-criteria
   ```
3. **Make your changes** with clear commits:
   ```bash
   git commit -m "Add detection for promotional link spam"
   ```
4. **Push** to your fork:
   ```bash
   git push origin improve-detection-criteria
   ```
5. **Create a Pull Request** with:
   - Clear title and description
   - List of changes made
   - Test results showing improvement
   - Examples demonstrating the fix/enhancement

## Areas for Improvement

### High Priority

- **Reduce False Positives**: Legitimate discussions being flagged
- **Improve Multi-language Support**: Better detection in non-English discussions
- **Edge Cases**: Handle discussions with code, tables, special formatting

### Medium Priority

- **Performance**: Optimize script execution time
- **Error Handling**: Better error messages and recovery
- **Documentation**: Improve guides and examples

### Ideas for Enhancement

- Support for discussion categories
- Integration with moderation tools
- Analytics/reporting features
- Configurable sensitivity levels
- Batch processing historical discussions
- A/B testing different prompts

## Community Guidelines

- Be respectful and constructive
- Focus on improving the tool for everyone
- Share knowledge and help others
- Test thoroughly before submitting
- Document your changes clearly

## Questions?

- Open an issue for discussion
- Check the [Usage Guide](USAGE.md)
- Review existing issues and PRs

## License

By contributing, you agree that your contributions will be licensed under the same terms as the project.

## Recognition

Contributors who make significant improvements will be recognized in the project README.

Thank you for helping make GitHub Discussions safer and more productive for everyone!
