# Release Process

This project uses GitHub Actions to automate the release process. There are two ways to create a release:

## Method 1: Manual Release (Recommended)

1. Go to the [Actions tab](../../actions) in your GitHub repository
2. Select "Publish Release" workflow
3. Click "Run workflow"
4. Enter the version number (e.g., `1.0.0`)
5. Click "Run workflow"

The workflow will:
- Validate the version format
- Build and test the code
- Create a Git tag (if permissions allow)
- Create a GitHub release
- Build and attach JAR files to the release
- Update documentation

## Method 2: Tag-Based Release

1. Create and push a tag locally:
   ```bash
   git tag -a v1.0.0 -m "Release v1.0.0"
   git push origin v1.0.0
   ```

2. The workflow will automatically trigger and create the release

## Release Artifacts

Each release includes:
- `cdk-common-{version}.jar` - The main library JAR
- `cdk-common-{version}.jar.sha256` - SHA256 checksum
- `cdk-common-{version}-sources.jar` - Source code JAR
- `cdk-common-{version}-sources.jar.sha256` - SHA256 checksum  
- `cdk-common-{version}.pom` - Maven POM file with dependencies

## Version Format

Versions must follow semantic versioning:
- `X.Y.Z` for stable releases (e.g., `1.0.0`)
- `X.Y.Z-suffix` for pre-releases (e.g., `1.0.0-beta1`)

## Troubleshooting

### Permission Denied Error

If you see "Write access to repository not granted" when using workflow_dispatch:
- This is expected behavior - the workflow uses the default GITHUB_TOKEN which has limited permissions
- The release will still be created without the tag
- You can manually create the tag before running the workflow

### Release Already Exists

If a release with the same version already exists:
- Delete the existing release and tag from GitHub
- Or use a different version number

### Build Failures

If the build fails:
- Check the test results in the workflow logs
- Ensure all dependencies are available
- Verify the code compiles locally with `mvn clean package`

## Manual Release (Without GitHub Actions)

If needed, you can create a release manually:

```bash
# Update version in pom.xml
mvn versions:set -DnewVersion=1.0.0
mvn versions:commit

# Build the release
mvn clean package source:jar

# Create checksums
cd target
sha256sum cdk-common-1.0.0.jar > cdk-common-1.0.0.jar.sha256
sha256sum cdk-common-1.0.0-sources.jar > cdk-common-1.0.0-sources.jar.sha256

# Create tag and push
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0

# Create GitHub release and upload artifacts manually via GitHub UI
```

## Post-Release

After a successful release:
1. The version badge in README.md will be automatically updated (if present)
2. Download and verify the artifacts from the release page
3. Update any dependent projects to use the new version
4. Consider announcing the release if it contains significant changes