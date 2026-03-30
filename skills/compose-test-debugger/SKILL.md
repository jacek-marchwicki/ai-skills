---
name: compose-test-debugger
description: Use this skill when running or debugging integration tests that use Jetpack Compose. It guides the user through adding a debug rule, running tests, fetching UI traces from logcat, and analyzing failures. Use this whenever a user mentions Jetpack Compose tests failing, timeouts, or UI assertion errors in Android tests.
---

# Jetpack Compose Test Debugger

This skill provides a structured workflow for debugging Jetpack Compose integration tests using a custom `DebugComposeErrorRule`. This rule captures the Compose semantics tree when a test fails due to a `ComposeTimeoutException` or `AssertionError`.

## Workflow

### 1. Ensure `DebugComposeErrorRule` exists in the project
- Check if a class named `DebugComposeErrorRule` is present in the test sources (e.g., `src/androidTest/java`).
  - If it does NOT exist, add it to your project using the bundled source located at:
    - `.junie/skills/compose-test-debugger/resources/DebugComposeErrorRule.kt`
  - Adjust the package name to match your project's test package structure if needed.

### 2. Add the rule to your test
Every Compose integration test class should have the `DebugComposeErrorRule` rule.

```kotlin
class YourTestClass {
    @get:Rule
    val composeTestRule = createComposeRule()

    @get:Rule
    val debugComposeErrorRule = DebugComposeErrorRule(composeTestRule)
    
    // ... tests
}
```

### 3. Run the test
Run the failing test using the standard test runner.

### 4. Fetch the TRACE
If the test fails, use the bundled script to fetch the TRACE output from logcat. This TRACE contains the full semantics tree at the moment of failure.

To fetch the trace, execute via the `bash` tool: `scripts/fetch_trace.sh`

### 5. Analyze the Failure
Compare the expected UI state (from the test code) with the actual UI state found in the TRACE.

- Check if elements are missing: Look for the semantics node you were trying to interact with.
- Check for incorrect properties: Verify text, content descriptions, or state.
- Check for overlapping UI: Elements might be present but not clickable or obscured.
- Check if a progress bar is displayed, and the test should wait for it to complete.

### 6. Decide on the Fix
- Test Failure: If the TRACE shows the application is in the correct state but the test is looking for the wrong thing (or has a timing issue), fix the test code.
- Application Failure: If the TRACE shows the application UI is incorrect (e.g., a bug in the Compose code), fix the application code.

## Bundled Resources

### Rule source
- `resources/DebugComposeErrorRule.kt`: Source code for the JUnit 4 rule to copy into the project when missing.

### Scripts
- `scripts/fetch_trace.sh`: Fetches the last captured TRACE from logcat using `adb`.
