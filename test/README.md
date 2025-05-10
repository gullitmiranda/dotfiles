# Tests for Dotfiles

This directory contains tests for the dotfiles utilities and scripts.

## Available Tests

### create_shell_stub_test.sh

Tests the `create_shell_stub` utility which creates or updates shell configuration files with tagged content blocks.

**Features tested:**

- Creating new files with default and custom tags
- Updating existing files
- Preserving content outside of tagged blocks
- Creating nested directories
- Handling multiline content

**Usage:**

```bash
./test/create_shell_stub_test.sh [OPTIONS]
```

**Options:**

- `--keep-logs`: Keep test logs after running (useful for debugging)

## Running All Tests

Currently, there's no single command to run all tests. Run each test script individually.

## Adding New Tests

When adding new tests, follow these guidelines:

1. Create a separate test script for each utility
2. Use meaningful test names
3. Implement proper setup and teardown
4. Include both positive and negative test cases
5. Document the test script with usage instructions

Each test script should be self-contained and clean up after itself.
