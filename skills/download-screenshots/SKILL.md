---
name: download-screenshots
description: Download and analyze failure screenshots from Android devices after UI test execution. Use this skill whenever a UI test (Espresso or UI Automator) fails, especially when the cause of failure is not clear from logs or stack traces. It helps visualize what was actually on the screen at the moment of failure to determine if the issue is in the test code or the application.
---

# Download Screenshot Skill

A skill for downloading and analyzing screenshots captured on Android device/emulator after UI test failures.

## Workflow

When a UI test fails, follow these steps to retrieve and analyze visual evidence:

### 1. Identify the failing test
Note the Class Name and Test Method Name of the failing test.

### 2. Download the latest screenshot
Use the bundled script to find and pull the latest screenshot matching the test pattern.

```bash
.agents/skills/download-screenshots/scripts/download_screenshot.sh <ClassName> <TestMethodName> [output_file]
```

**Example:**
Input: `CreateSubgroupTest`, `whenUserCreatesSubgroup_participantListIncludesOnlySpaceMembers`
```bash
.agents/skills/download-screenshots/scripts/download_screenshot.sh CreateSubgroupTest whenUserCreatesSubgroup_participantListIncludesOnlySpaceMembers failure_screenshot.png
```

### 3. Analyze the screenshot
Open and examine the downloaded image to understand the UI state.

1. **Open the image**: Use the `open` tool on the downloaded file.
2. **Examine the content**: Check for:
    - Unexpected dialogs, error messages, or "ANR" (App Not Responding) popups.
    - Missing UI elements (buttons, text fields, etc.) that the test was looking for.
    - Incorrect data or states displayed on the screen.
    - Layout issues (overlapping components, cut-off text).

### 4. Determine root cause
Based on the visual evidence, decide if the fix should be in the test or the production code:
- **Test issue**: The app is correct, but the test expectations are outdated or too strict (e.g., waiting for the wrong element).
- **App bug**: The UI shows incorrect data or an error state that should not be there.

## Manual Commands (Reference)

If the script fails, you can run these commands manually:

1. **Find the latest file on device:**
```bash
FILE_NAME=$(adb shell ls -t "/sdcard/Pictures/screenshots/<ClassName>_<TestMethodName>-failure-*" | head -n 1 | tr -d '\r')
```

2. **Pull the file:**
```bash
adb pull "$FILE_NAME" .output.png
```

## Troubleshooting
- **No file found**: Ensure `ScreenshotTestRule` is used in the test class.
- **ADB issues**: Verify the device is connected with `adb devices`.
- **Permission denied**: Ensure you have storage permissions on the device.
