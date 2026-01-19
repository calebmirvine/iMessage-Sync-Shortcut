# iCloud Message Sync Automation

A robust macOS automation tool built in Swift to programmatically trigger the "Sync Now" action for Messages in iCloud.

## 🚀 Overview
Automating modern macOS System Settings (SwiftUI-based) is notoriously difficult for traditional AppleScript. This project leverages the native **macOS Accessibility API** and **CoreGraphics** to achieve reliable UI interaction, including deep element discovery and physical click simulation.

## 🛠 Technology Stack
- **Swift**: Core logic and process management.
- **Accessibility API (AXUIElement)**: Used for deep recursive searching of the SwiftUI element tree (BFS algorithm).
- **CoreGraphics (CGEvent)**: Simulates physical mouse movements and button presses (`leftMouseDown`/`leftMouseUp`).
- **AppKit (NSWorkspace)**: Handles URL scheme navigation to target specific System Settings panes.

## 💡 Key Features
- **Deep Search**: Recursively scans the UI hierarchy to find elements by Identifier or Label.
- **Visual Feedback**: Physically depresses the UI button on-screen for user confirmation.
- **Hardware Suppression**: Temporarily locks physical mouse movement during the click to prevent user interference.
- **Shortcuts Ready**: Designed to run as a single-block shell script within the Apple Shortcuts app.

## 📲 How to Integrate with Apple Shortcuts
1. Create a new Shortcut in the **Shortcuts app**.
2. Add a **"Run Shell Script"** action.
3. Set the shell to `/bin/zsh`.
4. Copy the Swift code from the source file and wrap it in a Swift execution block:
   ```bash
   /usr/bin/swift - <<'EOF'
   // [Swift Code Here]
   EOF
   ```
5. Grant the necessary **Accessibility Permissions** in System Settings when prompted.
