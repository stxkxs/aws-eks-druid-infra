# Contributing to CDK Common

Thank you for your interest in contributing to CDK Common! We welcome contributions from the community and are grateful for any help you can provide.

## Code of Conduct

Please note that this project is released with a [Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples**
- **Include stack traces and logs**
- **Describe the behavior you observed and expected**
- **Include your environment details** (Java version, OS, etc.)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:

- **Use a clear and descriptive title**
- **Provide a detailed description of the suggested enhancement**
- **Provide specific examples to demonstrate the enhancement**
- **Describe the current behavior and expected behavior**
- **Explain why this enhancement would be useful**

### Pull Requests

1. **Fork the repository** and create your branch from `main`
2. **Follow the coding standards** (see below)
3. **Write tests** for your changes
4. **Ensure all tests pass** (`./mvnw test`)
5. **Update documentation** as needed
6. **Follow commit conventions** (see below)
7. **Submit your pull request**

## Development Setup

### Prerequisites

- Java 21+
- Maven 3.9.6+
- Git
- AWS CLI (configured)
- AWS CDK CLI

### Getting Started

```bash
# Clone your fork
git clone https://github.com/your-username/cdk-common.git
cd cdk-common

# Add upstream remote
git remote add upstream https://github.com/tinstafl/cdk-common.git

# Install dependencies
./mvnw clean install

# Run tests
./mvnw test
```

## Coding Standards

### Java Style Guide

- Use 2 spaces for indentation
- Maximum line length: 120 characters
- Use meaningful variable and method names
- Add JavaDoc comments for public methods and classes
- Follow standard Java naming conventions

### Code Quality

Before submitting:

```bash
# Format code
./mvnw spotless:apply

# Run static analysis
./mvnw spotbugs:check
./mvnw pmd:check
./mvnw checkstyle:check

# Run all checks
./mvnw clean verify
```

## Commit Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): description

[optional body]

[optional footer(s)]
```

### Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation only
- **style**: Code style changes
- **refactor**: Code refactoring
- **perf**: Performance improvements
- **test**: Adding or updating tests
- **build**: Build system changes
- **ci**: CI configuration changes
- **chore**: Other changes

### Examples

```bash
feat(eks): add support for Karpenter autoscaling
fix(lambda): correct IAM permission for S3 access
docs: update README with new construct examples
test(vpc): add unit tests for security groups
```

## Testing

### Running Tests

```bash
# Run all tests
./mvnw test

# Run specific test class
./mvnw test -Dtest=ClassName

# Run with coverage
./mvnw clean test jacoco:report
```

### Writing Tests

- Write unit tests for all new functionality
- Maintain test coverage above 70%
- Use meaningful test names that describe the scenario
- Follow the Arrange-Act-Assert pattern

## Documentation

- Update README.md if adding new features
- Add JavaDoc comments for public APIs
- Update relevant documentation in the `docs/` directory
- Include examples for new constructs

## Review Process

1. **Automated checks** run on all PRs
2. **Code review** by maintainers
3. **Testing** in multiple environments
4. **Documentation review**
5. **Final approval and merge**

## Release Process

Releases are managed by maintainers:

1. Version bump in `pom.xml`
2. Update CHANGELOG.md
3. Create git tag
4. GitHub Actions publishes release

## Questions?

- Open a [GitHub Discussion](https://github.com/tinstafl/cdk-common/discussions)
- Check existing [Issues](https://github.com/tinstafl/cdk-common/issues)
- Review the [Documentation](docs/)

## Recognition

Contributors are recognized in:
- CHANGELOG.md for each release
- GitHub contributors page
- Project documentation

Thank you for contributing to CDK Common! 🎉