# Local Validation Commands

Run these commands locally to validate your code before pushing to GitHub. These mirror the checks performed by the GitHub Actions workflow.

## Quick Validation (Most Common)

```bash
# Run all essential checks
mvn clean verify

# Or run them individually:
mvn clean compile              # Compile the code
mvn test                        # Run tests
mvn checkstyle:check           # Check code style
mvn pmd:check pmd:cpd-check    # Run PMD analysis
mvn spotbugs:check             # Run SpotBugs analysis
```

## Full GitHub Actions Validation

### 1. Build and Test
```bash
# Clean compile
mvn clean compile -B

# Run tests
mvn test -B

# Run tests with coverage
mvn clean test jacoco:report -B
```

### 2. Code Coverage
```bash
# Generate JaCoCo coverage report
mvn clean test jacoco:report -B

# View coverage report (HTML)
open target/site/jacoco/index.html
```

### 3. Static Analysis Tools

#### Checkstyle (Code Style)
```bash
# Check for violations
mvn checkstyle:check -B

# Generate HTML report
mvn checkstyle:checkstyle -B
open target/site/checkstyle.html
```

#### PMD (Code Quality)
```bash
# Run PMD and CPD (Copy-Paste Detector)
mvn pmd:pmd pmd:cpd -B

# Check for violations
mvn pmd:check pmd:cpd-check -B

# View reports
open target/site/pmd.html
open target/site/cpd.html
```

#### SpotBugs (Bug Detection)
```bash
# Run SpotBugs analysis
mvn clean compile spotbugs:spotbugs -B

# Check for bugs
mvn spotbugs:check -B

# View HTML report
mvn spotbugs:gui  # Opens GUI
# Or view XML report at: target/spotbugsXml.xml
```

### 4. Dependency Checks

#### OWASP Dependency Check (Security)
```bash
# Run dependency check (takes time on first run)
mvn dependency-check:check -B

# View reports
open reports/dependency-check-report.html
```

#### Maven Dependency Analysis
```bash
# Analyze dependencies
mvn dependency:analyze -B

# Check for duplicate dependencies
mvn dependency:analyze-duplicate -B

# Check dependency management
mvn dependency:analyze-dep-mgt -B

# Check for available updates
mvn versions:display-dependency-updates -B
mvn versions:display-plugin-updates -B
```

## Complete Validation Script

Create a script `validate.sh`:

```bash
#!/bin/bash
set -e

echo "🔍 Running complete validation..."

echo "📦 Clean and compile..."
mvn clean compile -B

echo "🧪 Running tests with coverage..."
mvn test jacoco:report -B

echo "✅ Running Checkstyle..."
mvn checkstyle:check -B

echo "🔎 Running PMD..."
mvn pmd:check pmd:cpd-check -B

echo "🐛 Running SpotBugs..."
mvn spotbugs:check -B

echo "🔒 Running OWASP Dependency Check..."
mvn dependency-check:check -B -DskipTests

echo "📊 Analyzing dependencies..."
mvn dependency:analyze -B

echo "✨ All validations passed!"
```

Make it executable:
```bash
chmod +x validate.sh
./validate.sh
```

## Quick Commands for Specific Checks

```bash
# Just compile
mvn clean compile -B

# Just run tests
mvn test -B

# Just check style
mvn checkstyle:check -B

# Just check for bugs
mvn spotbugs:check -B

# Just check security
mvn dependency-check:check -B

# Generate all reports without failing
mvn clean verify -DskipTests -Dmaven.test.skip=true \
    checkstyle:checkstyle \
    pmd:pmd pmd:cpd \
    spotbugs:spotbugs \
    dependency-check:check \
    -Dfailsafe.skip=true \
    -Dcheckstyle.skip=false \
    -Dpmd.skip=false \
    -Dspotbugs.skip=false
```

## CI/CD Simulation

To simulate the exact GitHub Actions environment:

```bash
# Run with the same flags as CI
mvn clean install -B -DskipTests=false

# Run with all checks but continue on failure (like CI)
mvn clean verify -B \
    -Dmaven.checkstyle.failsOnError=false \
    -Dmaven.pmd.failOnViolation=false \
    -Dspotbugs.failOnError=false || true
```

## Tips

1. **Before committing**: Run at least `mvn clean compile test`
2. **Before pushing**: Run `mvn clean verify`
3. **Before PR**: Run the complete validation script
4. **First time setup**: OWASP check downloads a large database on first run (can take 5-10 minutes)

## Troubleshooting

If any command fails:

1. **Checkstyle violations**: Fix formatting issues or suppress with comments
2. **PMD violations**: Refactor code or add `@SuppressWarnings("PMD.RuleName")`
3. **SpotBugs issues**: Fix bugs or add exclusions to `spotbugs-exclude.xml`
4. **Test failures**: Fix failing tests or skip with `mvn verify -DskipTests`
5. **OWASP vulnerabilities**: Update dependencies or add suppressions to `dependency-check-suppressions.xml`

## GitHub Actions Workflow Reference

These commands correspond to the following GitHub Actions jobs:
- `build-and-test`: Compilation and tests
- `code-coverage`: JaCoCo coverage analysis
- `checkstyle-analysis`: Code style checking
- `pmd-analysis`: PMD static analysis
- `spotbugs-analysis`: Bug detection
- `dependency-check`: OWASP security scanning
- `dependency-analysis`: Maven dependency analysis