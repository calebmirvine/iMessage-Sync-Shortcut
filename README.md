# iCloud Message Sync Automation

This tool automates the "Sync Now" action for Messages in iCloud on macOS. It was built to replace a manual process with a more reliable, programmatically triggered solution.

## Project Context
I developed this for my current workplace to handle a specific automation need. The goal was to ensure iMessage synchronization remains up to date across systems without manual intervention.

### Core Skills
- **Swift Development**: Using `Accessibility API` and `CoreGraphics` for UI interaction.
- **AppleScript**: Prototyping and legacy fallback logic.
- **Recursive Navigation**: Implementing search logic to find dynamic UI elements.
- **Platform Detection**: Using Apple Shortcuts to route logic based on the device type.

## Cross-Platform Intelligence
The automation is wrapped in an Apple Shortcut that detects the host device and executes the appropriate logic:

- **iOS**: Uses a direct URL scheme (`prefs:root=APPLE_ACCOUNT&path=ICLOUD_SERVICE/com.apple.Dataclass.Messages`) to quickly open the specific iCloud settings pane.
- **macOS**: An intelligent handoff that prioritizes a **Swift-based native execution** for speed and precision, with an **AppleScript fallback** for menu-bar navigation if needed.

## Implementation: AppleScript vs. Swift
The project evolved from a prototype into a more robust native tool.

### AppleScript (Prototype)
The initial version (`navigation.applescript`) used standard System Events to interact with the menu bar and windows. While effective for simple tasks, it faced challenges with the more dynamic SwiftUI-based System Settings in newer macOS versions.

### Swift (Native Implementation)
To achieve better reliability and precision, I refactored the core logic into Swift (`navigation.swift`).
- **Precision**: Uses the `Accessibility API` to find elements by their internal identifiers.
- **Speed**: Provides a faster response time compared to the AppleScript interpreter.
- **Visual Feedback**: Uses `CoreGraphics` to simulate physical clicks, giving the user visible confirmation of the sync action.

## Key Features
- **Dynamic UI Discovery**: Searches the UI hierarchy recursively to find buttons by ID or Label.
- **Input Management**: Lock the cursor during the click event to prevent user interference.
- **Shortcuts Ready**: Designed for seamless integration into macOS/iOS Shortcuts.


