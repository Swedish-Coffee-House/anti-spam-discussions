# Detection Examples

This document shows examples of discussions that would be flagged as spam vs. legitimate discussions.

## Spam Examples (Would be flagged)

### Example 1: Empty or Very Short Body
```
Title: Help
Body: 
```
**Why**: No meaningful content

### Example 2: Single Word
```
Title: Question
Body: Account
```
**Why**: No context or explanation

### Example 3: Gibberish
```
Title: asdfgh
Body: qwerty zxcvbn asdfghjkl
```
**Why**: Nonsensical text

### Example 4: Link Only
```
Title: Check this
Body: [document.pdf](https://example.com/file.pdf)
```
**Why**: No context for the link

### Example 5: Promotional Content
```
Title: Best Software!
Body: Click here to get 50% off on our amazing product! Limited time offer!
Visit: https://example.com/buy-now
```
**Why**: Advertisement/spam

### Example 6: Repetitive Content
```
Title: Help help help
Body: Please help please help please help please help please help
```
**Why**: Repetitive, no meaningful information

### Example 7: Off-Topic Personal Message
```
Title: John Smith
Body: Call me about the meeting tomorrow. My number is 555-1234.
```
**Why**: Personal message, not project-related

### Example 8: Incomplete Template
```
Title: Feature Request
Body: ### Description
A clear description of the feature

### Use Case
Describe how it would be used

### Benefits
List the benefits
```
**Why**: Template not filled in, just placeholders

### Example 9: Quote Without Context
```
Title: From another discussion
Body: > This is a quote from someone else's comment
> in a different discussion somewhere
```
**Why**: No context or original content

### Example 10: Single Emoji or Symbol
```
Title: 👋
Body: 🔥
```
**Why**: No meaningful content

## Legitimate Examples (Would NOT be flagged)

### Example 1: Bug Report
```
Title: Application crashes when processing large files

Body: 
### Description
The application crashes with an out-of-memory error when processing files larger than 500MB.

### Steps to Reproduce
1. Open the application
2. Try to load a file larger than 500MB
3. Observe the crash

### Expected Behavior
The application should handle large files gracefully.

### Environment
- OS: Ubuntu 22.04
- Version: 2.3.1
```
**Why**: Detailed, relevant, helpful

### Example 2: Feature Request
```
Title: Add support for dark mode

Body:
It would be great if this project supported a dark mode theme. Many users prefer dark mode for reduced eye strain.

Proposed implementation:
- Add a theme toggle in settings
- Use CSS variables for colors
- Persist user preference

This would improve accessibility and user experience.
```
**Why**: Well-explained request with details

### Example 3: Question with Context
```
Title: How to configure authentication for this project?

Body:
I'm trying to set up OAuth authentication but I'm running into issues. Here's my configuration:

```yaml
oauth:
  client_id: xxx
  callback_url: https://example.com/callback
```

I'm getting a 401 error. Has anyone successfully set this up? What am I missing?
```
**Why**: Specific question with context

### Example 4: Discussion Topic
```
Title: Best practices for testing in this framework?

Body:
I've been using this framework for a few months and I'm curious about testing strategies.

Currently I use:
- Unit tests for components
- Integration tests for APIs
- E2E tests for critical flows

What are others doing? Any recommendations for tools that work well with this framework?
```
**Why**: Relevant community discussion

### Example 5: Documentation Question
```
Title: Clarification needed on installation steps

Body:
The README mentions running `npm install` but I'm getting an error about Node version.

Error message:
```
error: Requires Node.js 14 or higher
```

Do I need to upgrade Node.js first? The docs don't mention the minimum version requirement.
```
**Why**: Legitimate documentation inquiry

### Example 6: Sharing Resources (with context)
```
Title: Useful tutorial I found for beginners

Body:
I found this tutorial really helpful when learning this framework:
https://example.com/tutorial

It covers:
- Basic setup
- Common patterns
- Best practices

Thought it might help others getting started. Not affiliated, just found it useful!
```
**Why**: Sharing with explanation and context

### Example 7: Feedback
```
Title: Great project! Small suggestion about the API

Body:
First, thanks for this amazing project! I've been using it in production for 6 months.

One small suggestion: the error messages from the API could be more descriptive. Currently:
```
Error: Invalid request
```

It would help to know which field is invalid. Something like:
```
Error: Invalid request - 'email' field is required
```

Just a thought! Keep up the great work.
```
**Why**: Constructive feedback with examples

### Example 8: Problem Solving Discussion
```
Title: Approach for handling concurrent requests?

Body:
I'm building an application that needs to handle multiple concurrent requests to the API.

I'm considering two approaches:
1. Queue system with workers
2. Promise.all() with rate limiting

Has anyone dealt with this? What approach worked best? Any gotchas I should know about?

Current context: ~100 requests per minute, need to stay under API rate limits.
```
**Why**: Technical discussion with clear context

## Edge Cases

### Borderline Case 1: Very Short but Valid
```
Title: Installation fails on Windows
Body: Getting error: "ENOENT: no such file or directory". Help?
```
**Decision**: Likely PASS - Short but has specific error and clear issue

### Borderline Case 2: Non-English Content
```
Title: 如何配置这个项目？
Body: 我在尝试配置OAuth认证，但遇到了一些问题。有人能帮忙吗？
```
**Decision**: Likely PASS - Legitimate question in Chinese

### Borderline Case 3: Link with Some Context
```
Title: Related issue
Body: This might be related: https://github.com/owner/repo/issues/123
```
**Decision**: Borderline - Minimal but might be legitimate reference

## Tips for Avoiding False Positives

When creating legitimate discussions:

1. **Provide Context**: Explain the background and what you need
2. **Be Specific**: Include error messages, steps taken, etc.
3. **Use Clear Titles**: Describe the actual topic
4. **Add Details**: More information is better than less
5. **Show Effort**: Demonstrate you've tried to solve it
6. **Stay On Topic**: Make sure it relates to the project

## Notes

- The AI model considers all factors together, not just individual elements
- Context matters: a short question with code is different from just "help"
- Legitimate discussions typically show effort and provide value to the community
- When in doubt, add more details and context to your discussion
