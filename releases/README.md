# Release Notes

This folder contains release notes for each version of the CDK Common Library.

## Usage

### Automatic Discovery
The release workflow will automatically look for a file named `v{VERSION}.md` in this folder.
For example, if releasing version `1.0.0`, it will look for `releases/v1.0.0.md`.

### Manual Specification
You can also specify a different file name in the workflow dispatch inputs.

## Creating Release Notes

1. Copy the template file: `cp TEMPLATE.md v{VERSION}.md`
2. Fill in the release details
3. Commit the file before creating the release
4. The workflow will automatically use it

## File Naming Convention

- Standard releases: `v1.0.0.md`
- Pre-releases: `v1.0.0-beta1.md`
- Release candidates: `v1.0.0-rc1.md`

## Benefits

- Write release notes in your IDE with full markdown preview
- Version control your release notes
- No issues with YAML escaping or multiline strings
- Can be reviewed in PR before release
- Reusable if release needs to be recreated