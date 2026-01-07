---
invokable: true
---

Run markdownlint on the specified file or directory to check for Markdown formatting issues.

This will check for common Markdown formatting problems including:
- Proper heading structure
- List formatting
- Link formatting
- Code block formatting
- And many other style and consistency issues

Usage:
markdownlint [options] <pattern>...

Where pattern is a file or directory path to check.

Configuration is defined in .continue/rules/markdownlint-config.json

Common options:
--fix     Automatically fix basic formatting issues
-c        Specify configuration file
--output  Save results to a file

Example usage:
markdownlint README.md                             # Check README.md
markdownlint --fix README.md                       # Fix README.md
markdownlint -c .continue/rules/markdownlint-config.json *.md  # Use project config
markdownlint --fix --output report.txt *.md        # Fix all md files and save report

For full documentation, visit: https://github.com/DavidAnson/markdownlint

Always validate fixes by reviewing the changes before committing.
