---
name: markdown-rules
globs: *.{md,mdx}
---

# Project Rules and Conventions

This project uses several tools to maintain code quality and consistency:

## Markdown Linting

We use [markdownlint](https://github.com/DavidAnson/markdownlint) to ensure consistent Markdown formatting.

### Configuration

The markdownlint configuration is located at `.continue/rules/markdownlint-config.json` and disables certain rules that aren't relevant to our documentation style:

- `MD013`: Line length (we allow long lines for better readability)
- `MD024`: Duplicate headings (sometimes intentional for organization)
- `MD033`: Inline HTML (allowed for formatting tables and special cases)
- And several others that conflict with our documentation style

### Usage

To check Markdown files for issues:

```bash
markdownlint README.md
```

To automatically fix basic formatting issues:

```bash
markdownlint --fix README.md
```

### Custom Slash Command

Use `/markdownlint` in Continue to get help with using markdownlint on this project.

## Other Quality Tools

This project also uses:

- EditorConfig for consistent indentation and line endings
- JSON for structured configuration files
- Pre-commit hooks for basic validation
