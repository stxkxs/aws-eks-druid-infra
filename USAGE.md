# Using CDK Common Library

## Download from GitHub Releases

The CDK Common library is distributed as JAR files through GitHub Releases. Each release includes:

- `cdk-common-{version}.jar` - The main library JAR
- `cdk-common-{version}-sources.jar` - Source code for IDE integration
- `cdk-common-{version}.pom` - POM file with dependency information
- `.sha256` files - Checksums for verification

### Latest Release

Download the latest release from:
https://github.com/tinstafl/cdk-common/releases/latest

## Manual Installation

### For Maven Projects

1. Download the JAR and POM files from the release
2. Install to your local Maven repository:

```bash
VERSION=1.0.0  # Replace with actual version
mvn install:install-file \
  -Dfile=cdk-common-${VERSION}.jar \
  -DpomFile=cdk-common-${VERSION}.pom \
  -DgroupId=io.tinstafl \
  -DartifactId=cdk-common \
  -Dversion=${VERSION} \
  -Dpackaging=jar
```

3. Add to your `pom.xml`:

```xml
<dependency>
    <groupId>io.tinstafl</groupId>
    <artifactId>cdk-common</artifactId>
    <version>1.0.0</version>
</dependency>
```

### For Gradle Projects

1. Download the JAR to a `libs` directory in your project
2. Add to your `build.gradle`:

```gradle
dependencies {
    implementation files('libs/cdk-common-1.0.0.jar')
    
    // Also add the CDK dependencies
    implementation 'software.amazon.awscdk:aws-cdk-lib:2.199.0'
    implementation 'software.constructs:constructs:[10.0.0,11.0.0)'
}
```

### Using GitHub as Maven Repository

You can also configure Maven to download directly from GitHub Releases:

```xml
<repositories>
    <repository>
        <id>github-cdk-common</id>
        <url>https://github.com/tinstafl/cdk-common/releases/download</url>
        <snapshots>
            <enabled>false</enabled>
        </snapshots>
    </repository>
</repositories>
```

## Verifying Downloads

Always verify the SHA256 checksum after downloading:

```bash
# On Linux/Mac
sha256sum -c cdk-common-1.0.0.jar.sha256

# On Windows (PowerShell)
Get-FileHash cdk-common-1.0.0.jar -Algorithm SHA256
```

## Dependencies

This library requires the following dependencies (specified in the POM file):
- AWS CDK Lib: 2.199.0
- AWS SDK: 2.32.31
- Jackson: 2.19.2
- Lombok: 1.18.38
- Apache Commons IO: 2.20.0
- Apache Commons Lang3: 3.18.0
- And others as specified in the POM

## IDE Integration

### IntelliJ IDEA

1. Download both the JAR and sources JAR
2. Add the JAR to your project libraries
3. Attach the sources JAR for better code navigation
4. Ensure Lombok plugin is installed for annotation processing

### Eclipse

1. Add the JAR to your build path
2. Attach the sources JAR
3. Install Lombok for Eclipse

## Example Usage

```java
import io.tinstafl.execute.aws.vpc.VpcConstruct;
import io.tinstafl.model.main.Common;
import io.tinstafl.model.aws.vpc.VpcConf;
import software.amazon.awscdk.App;
import software.amazon.awscdk.Stack;

public class MyStack extends Stack {
    public MyStack(final App app, final String id) {
        super(app, id);
        
        Common common = Common.builder()
            .env("production")
            .region("us-east-1")
            .build();
            
        VpcConf vpcConf = VpcConf.builder()
            .name("my-vpc")
            .cidr("10.0.0.0/16")
            .build();
            
        VpcConstruct vpc = new VpcConstruct(this, common, vpcConf);
    }
}
```

## Troubleshooting

### ClassNotFoundException

Ensure all required dependencies are included in your project. Check the POM file for the complete list.

### Lombok Errors

Make sure annotation processing is enabled in your IDE and the Lombok plugin is installed.

### Version Conflicts

If you encounter version conflicts with AWS CDK or other dependencies, check the POM file for the exact versions used by this library.