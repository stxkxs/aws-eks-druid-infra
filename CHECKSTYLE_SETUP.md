# Checkstyle Configuration for IntelliJ IDEA

## Installing Checkstyle Plugin

1. Open IntelliJ IDEA
2. Go to **File** → **Settings** (or **IntelliJ IDEA** → **Preferences** on macOS)
3. Navigate to **Plugins**
4. Search for "CheckStyle-IDEA"
5. Click **Install** and restart IntelliJ

## Configuring Checkstyle

1. Go to **File** → **Settings** (or **IntelliJ IDEA** → **Preferences** on macOS)
2. Navigate to **Tools** → **Checkstyle**
3. Click the **+** button to add a new configuration
4. Choose **Use a local Checkstyle file**
5. Browse and select: `checkstyle.xml` from the project root
6. Give it a description like "Google Java Style"
7. Click **Next** and **Finish**
8. Check the box next to your new configuration to make it active
9. Click **Apply** and **OK**

## Using Checkstyle in IntelliJ

### Real-time Checking
- Checkstyle will automatically run on your Java files as you edit
- Violations appear as warnings in the editor

### Manual Scan
- Open the **Checkstyle** tool window (View → Tool Windows → Checkstyle)
- Click **Check Project** to scan all files
- Click **Check Module** to scan current module
- Click **Check Current File** to scan the file you're editing

### Keyboard Shortcuts
- You can assign keyboard shortcuts in **Settings** → **Keymap** → search for "Checkstyle"

## Suppressing Warnings

You can suppress specific Checkstyle warnings using comments:

```java
// Single line suppression
// CHECKSTYLE.SUPPRESS: MemberName
private String m_badName;

// Block suppression
// CHECKSTYLE.OFF: MemberName
private String m_name1;
private String m_name2;
// CHECKSTYLE.ON: MemberName
```

## Maven Integration

The same Checkstyle configuration is used by Maven:

```bash
# Check for violations
mvn checkstyle:check

# Generate HTML report
mvn checkstyle:checkstyle
```

The report will be generated at `target/site/checkstyle.html`

## Configuration Details

This project uses Google Java Style Guide with the following key rules:
- 2-space indentation
- 100 character line limit
- No wildcard imports
- Javadoc required for public methods
- Consistent naming conventions

The configuration file `checkstyle.xml` can be customized if needed, but changes should be discussed with the team to maintain consistency.